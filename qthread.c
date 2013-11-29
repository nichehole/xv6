/*
 * file:        qthread.c
 * description: simple emulation of POSIX threads
 * class:       CS 7600, Spring 2013
 */

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <assert.h>
#include <sys/time.h>
#include <fcntl.h>
#include <errno.h>
#include "qthread.h"

#define STACKSIZE (1 << 15)

/*
 * do_switch is defined in do-switch.s, as the stack frame layout
 * changes with optimization level, making it difficult to do with
 * inline assembler.
 */

extern void do_switch(void **location_for_old_sp, void *new_value);

/*
 * setup_stack(stack, function, arg1, arg2) - sets up a stack so that
 * switching to it from 'do_switch' will call 'function' with arguments
 * 'arg1' and 'arg2'. Returns the resulting stack pointer.
 *
 * works fine with functions that take one argument ('arg1') or no
 * arguments, as well.
 */

void *setup_stack(int *stack, void *func, void *arg1, void *arg2)
{
  int old_bp = (int)stack;	/* top frame - SP = BP */
  *(--stack) = 0x3A3A3A3A;    /* guard zone */
  *(--stack) = 0x3A3A3A3A;
  *(--stack) = 0x3A3A3A3A;

  /* this is the stack frame "calling" 'func'
   */
  *(--stack) = (int)arg2;     /* argument */
  *(--stack) = (int)arg1;     /* argument (reverse order) */
  *(--stack) = 0;             /* fake return address (to 'func') */

  /* this is the stack frame calling 'do_switch'
   */
  *(--stack) = (int)func;     /* return address */
  *(--stack) = old_bp;        /* %ebp */
  *(--stack) = 0;             /* %ebx */
  *(--stack) = 0;             /* %esi */
  *(--stack) = 0;             /* %edi */
  *(--stack) = 0xa5a5a5a5;    /* valid stack flag */

  return stack;
}

/* You'll need to do sub-second arithmetic on time. This is an easy
 * way to do it - it returns the current time as a floating point
 * number. The result is as accurate as the clock usleep() uses, so
 * it's fine for us.
 */
static double gettime(void)
{
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return tv.tv_sec + tv.tv_usec/1.0e6;
}

/* We don't have to define the qthread structure in qthread.h, since
 * the user program only sees pointers to it.
 */
struct qthread {
  /*
   * note - you can't use 'qthread_t*' in this definition, due to C
   * limitations. 
   * use 'struct qthread *' instead, which means the same thing:
   *    struct qthread *next;
   */

  void* retVal; //return value saved for later being used in join	
  int *stack;
  int *ptr;
  int detached;
  int fd;
  int finished;
  int waiting_on_read;
  int waiting_on_write;
  double timeout;
  struct qthread *next;
};

void append(qthread_t thread, struct thread_q *queue) {
  if (queue->head != NULL) {
    (queue->tail)->next = thread;
  } else {
    queue->head = thread;
  }
  queue->tail = thread;
}

qthread_t pop(struct thread_q *queue) {
  qthread_t top = queue->head;
  if (queue->tail != queue->head) {
    queue->head = queue->head->next;
  } else {
    queue->head = queue->tail = NULL;
  }
  if (top) top->next = NULL;
  return top;
}

/* A good organization is to keep a pointer to the 'current'
 * (i.e. running) thread, and a list of 'active' threads (not
 * including 'current') which are also ready to run.
 */

struct thread_q exit_queue;
struct thread_q active;
struct thread_q time_wait;
struct thread_q io_wait;

/* Note that on startup there's already a thread running thread - we
 * need a placeholder 'struct thread' so that we can switch away from
 * that to another thread and then switch back. 
 */

struct qthread os_thread = {};
struct qthread *current = &os_thread;

/* Beware - you cannot use do_switch to switch from a thread to
 * itself. If there are no other active threads (or after a timeout
 * the first scheduled thread is the current one) you should return
 * without switching. (why? because you haven't saved the current
 * stack pointer)
 */

/* qthread_yield - yield to the next runnable thread.
 */

int qthread_yield(void) {
  qthread_t t, prev, min_t;
  qthread_t exitingThread;
  double now, min, td;
  int nfds, f;
  int currExist = 0;
  struct timeval timeout;

  // freeing threads in the exit queue

  while (exitingThread = pop(&exit_queue)) {
    // push back if this the exiting thread is the current thread
    if (exitingThread == current) { 
      currExist = 1;      
    } else {
      // do cleanup thread
      if (exitingThread->stack)
        free(exitingThread->stack); // free stack
      free(exitingThread); // free thread structure
    }
  }

  if (currExist) append(current, &exit_queue);

  qthread_t old = current;
  while ((current = pop(&active)) == NULL) {
    now = gettime();
    min = now + 1;
    nfds = 0;
    // wake up sleeping threads
    for (prev = NULL, t = time_wait.head; t != NULL; prev = t, t = t->next) {
      if (t->timeout < now) {
        // fixing pointer in parent
        if (prev == NULL) {
          time_wait.head = t->next; // t is at head
        } else {
          prev->next = t->next; // t's parent point to t's child
        }
        current = t;
        if (t->next != NULL) {
          t->next = NULL; // remove t->next
        } else {
          time_wait.tail = prev; // t is at tail
        }
        if (current != old) {
          do_switch(&(old->ptr), current->ptr);
        }
        return;
      }
    }
    // wake up threads that are waiting for I/O
    fd_set read_fds, write_fds;
    FD_ZERO(&read_fds);
    FD_ZERO(&write_fds);
    while ((t = pop(&io_wait)) != NULL) {
      t->waiting_on_read = 0;
      t->waiting_on_write = 0;
      if (t->fd >= nfds) nfds = t->fd + 1;
      if (t->waiting_on_read) FD_SET(t->fd, &read_fds);
      if (t->waiting_on_write) FD_SET(t->fd, &write_fds);
      if (t->timeout < min) min = t->timeout;
      append(t, &active);
    }
    td = min - gettime();
    timeout.tv_sec = (int)td;
    timeout.tv_usec = (int)((td - timeout.tv_sec) * 1.0e6);
    select(nfds, &read_fds, &write_fds, NULL, &timeout);
  }
  if (current != old) do_switch(&(old->ptr), current->ptr);
  return 0;
}

/* Initialize a thread attribute structure. We're using an 'int' for
 * this, so just set it to zero.
 */

int qthread_attr_init(qthread_attr_t *attr) {
  *attr = 0;
  return 0;
}

/* The only attribute supported is 'detached' - if it is true a thread
 * will clean up when it exits; otherwise the thread structure hangs
 * around until another thread calls qthread_join() on it.
 */

int qthread_attr_setdetachstate(qthread_attr_t *attr, int detachstate) {
  *attr = detachstate;
  return 0;
}


/* a thread can exit by either returning from its main function or
 * calling qthread_exit(), so you should probably use a dummy start
 * function that calls the real start function and then calls
 * qthread_exit after it returns.
 */

void *dummy_start(void (*start)(), void *arg) {
  start(arg);
  qthread_exit(NULL);
}

/* qthread_create - create a new thread and add it to the active list
 */

int qthread_create(qthread_t *thread, qthread_attr_t *attr,
    qthread_func_ptr_t start, void *arg)
{
  *thread = (struct qthread *) malloc(sizeof(struct qthread));
  (*thread)->finished = 0;
  (*thread)->detached = (attr == NULL) ? 1 : *attr;
  (*thread)->stack = (int*) malloc(STACKSIZE * sizeof(int));
  (*thread)->ptr = (*thread)->stack + STACKSIZE;
  (*thread)->ptr = setup_stack((*thread)->ptr, dummy_start, start, arg);
  append(*thread, &active);
  append(current, &active);
  qthread_yield();

  return 0;
}

/* qthread_exit - sort of like qthread_yield, except we never
 * return. If the thread is joinable you need to save 'val' for a
 * future call to qthread_join; otherwise you can free allocated
 * memory. 
 */
void qthread_exit(void *val)
{
  qthread_t exitingThread = current;
  exitingThread->finished = 1;

  if (exitingThread->detached == 1) {
    //append to exit_queue for later being freed out of this queue
    append(exitingThread, &exit_queue);
  } else if (exitingThread->detached == 0) {
    //Should later be freed inside the qthread_join function
    exitingThread->retVal = val;
  }
  qthread_yield();
}

/* qthread_mutex_init/destroy - initialize (destroy) a mutex. Ignore
 * 'attr' - mutexes are non-recursive, non-debugging, and
 * non-any-other-POSIX-feature. 
 */
int qthread_mutex_init(qthread_mutex_t *mutex, qthread_mutexattr_t *attr) {
  mutex->locked = 0;
  return 0;
}

int qthread_mutex_destroy(qthread_mutex_t *mutex) {
  if(mutex->locked) mutex->locked = 0;
  mutex = NULL;
  return 0;
}

/* qthread_mutex_lock/unlock
 */
int qthread_mutex_lock(qthread_mutex_t *mutex)
{
  if (mutex->locked) {
    append(current, &mutex->waiting);
    qthread_yield();
  } else {
    mutex->locked = 1;
  }
  return 0;
}
int qthread_mutex_unlock(qthread_mutex_t *mutex)
{
  qthread_t thread = pop(&mutex->waiting);
  if (thread != NULL) {
    append(thread, &active);
  } else {
    mutex->locked = 0;
  }
  return 0;
}

/* qthread_cond_init/destroy - initialize a condition variable. Again
 * we ignore 'attr'.
 */
int qthread_cond_init(qthread_cond_t *cond, qthread_condattr_t *attr) {

  struct thread_q waiting = cond->waiting;
  waiting.head = NULL;
  waiting.tail = NULL;

  return 0;
}

int qthread_cond_destroy(qthread_cond_t *cond) {
  struct thread_q waiting = cond->waiting;
  waiting.head = NULL;
  waiting.tail = NULL;
  return 0;
}

/* qthread_cond_wait - unlock the mutex and wait on 'cond' until
 * signalled; lock the mutex again before returning.
 */
int qthread_cond_wait(qthread_cond_t *cond, qthread_mutex_t *mutex)
{
  mutex->locked = 0;
  append(current, &cond->waiting);
  qthread_yield();
  mutex->locked = 1;
  return 0;
}

/* qthread_cond_signal/broadcast - wake one/all threads waiting on a
 * condition variable. Not an error if no threads are waiting.
 */
int qthread_cond_signal(qthread_cond_t *cond)
{
  qthread_t thread = pop(&cond->waiting);
  if (thread != NULL) {
    append(thread, &active);
  }
  return 0;
}

int qthread_cond_broadcast(qthread_cond_t *cond) {

  qthread_t thread;

  while(thread = pop(&cond->waiting))
    append(thread, &active);

  return 0;
}

/* POSIX replacement API. These are all the functions (well, the ones
 * used by the sample application) that might block.
 *
 * If there are no runnable threads, your scheduler needs to block
 * waiting for one of these blocking functions to return. You should
 * probably do this using the select() system call, indicating all the
 * file descriptors that threads are blocked on, and with a timeout
 * for the earliest thread waiting in qthread_usleep()
 */

/* qthread_usleep - yield to next runnable thread, making arrangements
 * to be put back on the active list after 'usecs' timeout. 
 */
int qthread_usleep(long int usecs) {
  current->timeout = gettime() + usecs/1.0e6;
  append(current, &time_wait);
  qthread_yield();
  return 0;
}

/* make sure that the file descriptor is in non-blocking mode, try to
 * read from it, if you get -1 / EAGAIN then add it to the list of
 * file descriptors to go in the big scheduling 'select()' and switch
 * to another thread.
 */
ssize_t qthread_read(int sockfd, void *buf, size_t len) {
  /* set non-blocking mode every time. If we added some more
   * wrappers we could set non-blocking mode from the beginning, but
   * this is a lot simpler (if less efficient)
   */
  int ret, tmp;
  tmp = fcntl(sockfd, F_GETFL, 0);
  fcntl(sockfd, F_SETFL, tmp | O_NONBLOCK);
  while ((ret = read(sockfd, buf, len)) == -1 && errno == EAGAIN) {
    current->fd = sockfd;
    current->timeout = gettime() + 5;
    current->waiting_on_read = 1;
    append(current, &io_wait);
    qthread_yield();
  }
  return ret;
}

/* like read - make sure the descriptor is in non-blocking mode, check
 * if if there's anything there - if so, return it, otherwise save fd
 * and switch to another thread. Note that accept() counts as a 'read'
 * for the select call.
 */
int qthread_accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen)
{
  int ret, tmp;
  tmp = fcntl(sockfd, F_GETFL, 0);
  fcntl(sockfd, F_SETFL, tmp | O_NONBLOCK);
  while ((ret = accept(sockfd, addr, addrlen)) == -1 && errno == EAGAIN) {
    current->fd = sockfd;
    current->timeout = gettime() + 5; 
    current->waiting_on_read = 1;
    append(current, &io_wait);
    qthread_yield();
  }
  return ret;
}

/* Like read, again. Note that this is an output, rather than an input
 * - it can block if the network is slow, although it's not likely to
 * in most of our testing.
 */
ssize_t qthread_write(int sockfd, const void *buf, size_t len) {
  int ret, tmp;
  tmp = fcntl(sockfd, F_GETFL, 0);
  fcntl(sockfd, F_SETFL, tmp | O_NONBLOCK);
  while ((ret = write(sockfd, buf, len)) == -1 && errno == EAGAIN) {
    current->fd = sockfd;
    current->timeout = gettime() + 5;
    current->waiting_on_write = 1;
    append(current, &io_wait);
    qthread_yield();
  }
  return ret;
}

int qthread_join(qthread_t thread, void **retval) {
  int ret = 0;
  // check for consistency
  if(thread->detached == 0) {
    // wait untill thread is finished
    while(!thread->finished) qthread_usleep(50000);
    if (retval != NULL) *retval = thread->retVal;
    // free the thread and its stack
    free(thread->stack);
    free(thread);
  } else {
    puts("This thread is detached; So no join can be performed for it");
  }
  return ret;
}
