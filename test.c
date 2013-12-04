#include "types.h"
#include "stat.h"
#include "user.h"
#include "thread.h"

#define N 5

/*
void t1(int x) {
  for(;;) {
    printf(1, "abc: %d\n", x);
    sleep(10);
  }
}
*/

qthread_mutex_t m;
qthread_cond_t cv;

qthread_t pid[10];
int count = 0;

void t2_1(int pid) {
  printf(1, "thread %d is getting the lock\n", pid);
  qthread_mutex_lock(&m);
  printf(1, "thread %d locks\n", pid);
  sleep(500);
  printf(1, "thread %d woke up\n", pid);
  qthread_mutex_unlock(&m);
  printf(1, "thread %d unlocked\n", pid);
  //qthread_exit(0);
  //while (1) sleep(500);
}

void t2_2()
{
  qthread_mutex_lock(&m);
  printf(1, "thread 2 locks\n");
  printf(1, "thread 2 unlocked\n");
  qthread_mutex_unlock(&m);
  //qthread_exit(0);
  //while (1) sleep(500);
}

void t3()
{
  qthread_mutex_lock(&m);
  printf(1, "Thread3 lock\n");
  count++;
  printf(1, "count: %d\n", count);
  if (count < N)
    qthread_cond_wait(&cv, &m);
  if (count == N) qthread_cond_broadcast(&cv);
  count--;
  printf(1, "%d\n", count);
  qthread_mutex_unlock(&m);
  printf(1, "Thread3 unlocked\n");
  //qthread_exit(0);
}

int
main(int argc, char *argv[])
{
  int i;
  printf(1, "BEGIN\n");
  //int pid3;
  //uint x = 37;
  qthread_mutex_init(&m, 0);
  qthread_cond_init(&cv, 0);
  printf(1, "m: %d, cv: %d\n", m, cv);
  for (i = 0; i < N; ++i) {
    qthread_create(&pid[i], *t3, (void*)i);
    printf(1, "thread %d pid: %d\n", i, pid[i]);
  }

  for (i = 0; i < N; ++i)
    qthread_join(pid[i], 0);
  exit();
}
