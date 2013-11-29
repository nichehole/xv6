#define STACKSIZE (1<<10)

#define qthread_exit(v) threadop(1,v)
#define qthread_join(i,v) threadop(2,i,v)
#define qthread_mutex_lock(m) threadop(3,m)
#define qthread_mutex_unlock(m) threadop(4,m)
#define qthread_cond_wait(cv,m) threadop(5,cv,m)
#define qthread_cond_signal(cv) threadop(6,cv)
#define qthread_cond_broadcast(cv) threadop(7,cv)


struct thread_q {
  struct proc *head;
  struct proc *tail;
};

struct mutex {
  uint locked;
  struct thread_q waiting;
};

struct condvar {
  struct thread_q waiting;
};


typedef int qthread_t;

typedef void qthread_mutexattr_t; /* no mutex attributes needed */
typedef struct mutex qthread_mutex_t;

typedef void qthread_condattr_t;  /* no cond attributes needed */
typedef struct condvar qthread_cond_t;


void qthread_create(qthread_t *t, void *func, void *arg);
int qthread_mutex_init(qthread_mutex_t *mutex, qthread_mutexattr_t *attr);
int qthread_cond_init(qthread_cond_t *cond, qthread_condattr_t *attr);
