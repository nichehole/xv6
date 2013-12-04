#include "types.h"
#include "stat.h"
#include "user.h"
#include "thread.h"


void dummy_start(void (*start)(), void *arg) {
  start(arg);
  qthread_exit(0);
}

void qthread_create(qthread_t *t, void *func, void *arg) {
  uint *stack = (uint*) malloc(STACKSIZE * sizeof(int));
  stack += STACKSIZE;
  *t = threadop(0, dummy_start, func, arg, stack);
}

int qthread_mutex_init(qthread_mutex_t *mutex, qthread_mutexattr_t *attr) {
  if ((*mutex = threadop(8)) == -1) return -1;
  return 0;
}

/* qthread_cond_init/destroy - initialize a condition variable. Again
 * we ignore 'attr'.
 */
int qthread_cond_init(qthread_cond_t *cond, qthread_condattr_t *attr) {
  if ((*cond == threadop(9)) == -1) return -1;
  return 0;
}
