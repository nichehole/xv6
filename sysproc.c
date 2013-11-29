#include "types.h"
#include "x86.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"


int
sys_fork(void)
{
  return fork();
}

int
sys_threadop(void)
{
  uint op;
  void *func, *arg, *val;
  void *m, *cv;
  void **ret;
  uint *stack;
  int pid;

  if (argint(0, (void*)&op) < 0)
    return -1;
  switch (op) {
    case 0: // thread_create
      if (argptr(1, (void*)&func, sizeof(*func)) < 0)
        return -1;
      if (argptr(2, (void*)&arg, sizeof(*arg)) < 0)
        return -1;
      if (argint(3, (void*)&stack) < 0)
        return -1;
      //if (argint(4, &size) < 0)
      //  return -1;
      return thread_create(func, arg, stack);
      break;
    case 1: // thread_exit
      if (argptr(1, (void*)&val, sizeof(*val)) < 0)
        return -1;
        thread_exit(val);
        return 0; // not reached;
      break;
    case 2: // thread_join
      if (argint(1, (void*)&pid) < 0)
        return -1;
      if (argptr(2, (void*)&ret, sizeof(*ret)) < 0)
        return -1;
      return thread_join(pid, ret);
      break;

    case 3: // mutex_lock
      if (argptr(1, (void*)&m, sizeof(*m)) < 0)
        return -1;
      mutex_lock(m);
      return 0; // not reached
      break;

    case 4: // mutex_unlock
      if (argptr(1, (void*)&m, sizeof(*m)) < 0)
        return -1;

      mutex_unlock(m);
      return 0; // not reached
      break;

    case 5: // cv_wait
      if (argptr(1, (void*)&cv, sizeof(*cv)) < 0)
        return -1;
      if (argptr(2, (void*)&m, sizeof(*m)) < 0)
        return -1;
      cv_wait(cv, m);
      return 0; // not reached
      break;

    case 6: // cv_signal
      if (argptr(1, (void*)&cv, sizeof(*cv)) < 0)
        return -1;

      cv_signal(cv);
      return 0; // not reached
      break;

    case 7: // cv_broadcast
      if (argptr(1, (void*)&cv, sizeof(*cv)) < 0)
        return -1;

      cv_broadcast(cv);
      return 0; // not reached
      break;
    default:
      return -1;
  }
  return 0; // not reached
}

int
sys_mutex_lock(void)
{
  void *m;

  if (argptr(0, (void*)&m, sizeof(*m)) < 0)
    return -1;

  mutex_lock(m);
  return 0; // not reached
}

int
sys_mutex_unlock(void)
{
  void *m;

  if (argptr(0, (void*)&m, sizeof(*m)) < 0)
    return -1;

  mutex_unlock(m);
  return 0; // not reached
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return proc->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->pp->sz; // Chin
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;
  
  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
