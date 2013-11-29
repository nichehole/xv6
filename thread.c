#include "types.h"
#include "stat.h"
#include "user.h"
#include "thread.h"

void qthread_create(qthread_t *t, void *func, void *arg) {
  uint *stack = (uint*) malloc(STACKSIZE * sizeof(int));
  stack += STACKSIZE;
  *t = threadop(0, func, arg, stack);
}

int qthread_mutex_init(qthread_mutex_t *mutex, qthread_mutexattr_t *attr) {
  mutex->locked = 0;
  return 0;
}

/* qthread_cond_init/destroy - initialize a condition variable. Again
 * we ignore 'attr'.
 */
int qthread_cond_init(qthread_cond_t *cond, qthread_condattr_t *attr) {

  cond->waiting.head = 0;
  cond->waiting.tail = 0;

  return 0;
}
