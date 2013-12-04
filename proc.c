#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "thread.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

struct proc2 procs[NPROC];
static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;
  int i;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0) {
    p->state = UNUSED;
    return 0;
  }
  i = p - ptable.proc; // Chin
  p->pp = &procs[i]; // Chin
  initlock(&p->pp->mlock, "mtable");
  initlock(&p->pp->cvlock, "cvtable");

  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  initproc = p;
  if((p->pp->pgdir = setupkvm()) == 0) // Chin
    panic("userinit: out of memory?");
  inituvm(p->pp->pgdir, _binary_initcode_start, (int)_binary_initcode_size); // Chin
  p->pp->sz = PGSIZE; // Chin
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->pp->name, "initcode", sizeof(p->pp->name));
  p->pp->cwd = namei("/"); // Chin

  p->state = RUNNABLE;
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->pp->sz; // Chin
  if(n > 0){
    if((sz = allocuvm(proc->pp->pgdir, sz, sz + n)) == 0) // Chin
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pp->pgdir, sz, sz + n)) == 0) // Chin
      return -1;
  }
  proc->pp->sz = sz; // Chin
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pp->pgdir = copyuvm(proc->pp->pgdir, proc->pp->sz)) == 0){ // Chin
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->pp->sz = proc->pp->sz; // Chin

  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->pp->ofile[i]) // Chin
      np->pp->ofile[i] = filedup(proc->pp->ofile[i]); // Chin
  np->pp->cwd = idup(proc->pp->cwd); // Chin
 
  pid = np->pid;
  np->state = RUNNABLE;
  safestrcpy(np->pp->name, proc->pp->name, sizeof(proc->pp->name));
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
thread_exit(void *val)
{
  struct proc *p;

  proc->ret = val;
  if (proc == initproc)
    panic("init exiting");

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    if (p->parent == proc) {
      p->parent = initproc;
      if (p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

void
append(struct proc *p, struct thread_q *q) {
  if (q->head) {
    (q->tail)->next = p;
  } else {
    q->head = p;
  }
  q->tail = p;
}

struct proc*
pop(struct thread_q *q) {
  struct proc *top = q->head;
  if (q->tail != q->head) {
    q->head = q->head->next;
  } else {
    q->head = q->tail = 0;
  }
  if (top) top->next = 0;
  return top;
}

int
allocm() {
  int i;
  acquire(&proc->pp->mlock);
  for (i = 0; i < NOFILE; i++) {
    if (proc->pp->m[i].used == 0) {
      proc->pp->m[i].locked = 0;
      proc->pp->m[i].waiting.head = 0;
      proc->pp->m[i].waiting.tail = 0;
      proc->pp->m[i].used = 1;
      release(&proc->pp->mlock);
      return i;
    }
  }
  release(&proc->pp->mlock);
  return -1;
}

int freem(int mutex) {
  acquire(&proc->pp->mlock);
  proc->pp->m[mutex].locked = 0;
  proc->pp->m[mutex].waiting.head = 0;
  proc->pp->m[mutex].waiting.tail = 0;
  proc->pp->m[mutex].used = 1;
  release(&proc->pp->mlock);
  return 0;
}

int
alloccv() {
  int i;
  acquire(&proc->pp->cvlock);
  for (i = 0; i < NOFILE; i++) {
    if (proc->pp->cv[i].used == 0) {
      proc->pp->cv[i].waiting.head = 0;
      proc->pp->cv[i].waiting.tail = 0;
      proc->pp->cv[i].used = 1;
      release(&proc->pp->cvlock);
      return i;
    }
  }
  release(&proc->pp->cvlock);
  return -1;
}

int freecv(int condvar) {
  acquire(&proc->pp->cvlock);
  proc->pp->cv[condvar].waiting.head = 0;
  proc->pp->cv[condvar].waiting.tail = 0;
  proc->pp->cv[condvar].used = 0;
  release(&proc->pp->cvlock);
  return 0;
}


static void
mutex_lock1(struct mutex *m) {
  if (m->locked) {
    append(proc, &m->waiting);
    proc->state = SLEEPING;
    sched();
  } else {
    xchg(&m->locked, 1);
  }
}

void
mutex_lock(int mutex) {
  if (proc == 0)
    panic("sleep");
  acquire(&ptable.lock);
  mutex_lock1(&proc->pp->m[mutex]);
  release(&ptable.lock);
}

static void
mutex_unlock1(struct mutex *m) {
  struct proc *p = pop(&m->waiting);
  if (p) {
    p->state = RUNNABLE;
  } else {
    xchg(&m->locked, 0);
  }
}

void
mutex_unlock(int m) {
  acquire(&ptable.lock);
  mutex_unlock1(&proc->pp->m[m]);
  release(&ptable.lock);
}

void
cv_wait(int cv, int m) {
  if (proc == 0)
    panic("sleep");

  acquire(&ptable.lock);
  mutex_unlock1(&proc->pp->m[m]);

  append(proc, &proc->pp->cv[cv].waiting);
  proc->state = SLEEPING;
  sched();
  
  mutex_lock1(&proc->pp->m[m]);
  release(&ptable.lock);
}

void
cv_signal(int cv) {
  struct proc *p;

  acquire(&ptable.lock);
  p = pop(&proc->pp->cv[cv].waiting);
  if (p) {
    p->state = RUNNABLE;
  }
  release(&ptable.lock);
}

void
cv_broadcast(int cv) {
  struct proc *p;

  acquire(&ptable.lock);
  while ((p = pop(&proc->pp->cv[cv].waiting))) {
    p->state = RUNNABLE;
  }
  release(&ptable.lock);
}

int
thread_join(int pid, void **ret)
{
  struct proc *p;
  int havekids;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->pid == pid && p->state == ZOMBIE){
        // Found one.
        //pid = p->pid;
        *ret = p->ret;
        kfree(p->kstack);
        p->kstack = 0;
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->killed = 0;
        p->ret = 0;
        p->next = 0;
        release(&ptable.lock);
        return 0;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}

int
thread_create(void *func, void *arg1, void *arg2, uint *stack)
{
  struct proc *p;
  uint old_bp;
  int pid;
  
  if((p = allocproc()) == 0)
    return -1;
  old_bp = (uint)stack;
  p->parent = proc;
  p->pp = proc->pp;
  *p->tf = *proc->tf;
  *(--stack) = (int)arg2;
  *(--stack) = (int)arg1;
  *(--stack) = 0;

  p->tf->eax = 0;
  p->tf->ebp = old_bp;
  p->tf->esp = (uint)stack;
  p->tf->eip = (uint)func;

  pid = p->pid;
  p->state = RUNNABLE;
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");


  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->pp->ofile[fd]){ // Chin
      fileclose(proc->pp->ofile[fd]); // Chin
      proc->pp->ofile[fd] = 0; // Chin
    }
  }

  iput(proc->pp->cwd); // Chin
  proc->pp->cwd = 0; // Chin
  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      // cleanup the other threads
      if (p->pp == proc->pp) {
        kfree(p->kstack);
        p->kstack = 0;
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->killed = 0;
        p->ret = 0;
        p->next = 0;
      }
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pp->pgdir); // Chin
        p->state = UNUSED;
        p->pid = 0;
        p->parent = 0;
        p->pp->name[0] = 0;
        p->killed = 0;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  proc->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    initlog();
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  proc->state = SLEEPING;
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->pp->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}


