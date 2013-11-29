/* 
 * file:        philosopher.c
 * description: Dining philosophers, from CS 5600
 *
 */

#include "types.h"
#include "user.h"

int nforks;
qthread_mutex_t m;
qthread_cond_t C[10];
int fork_in_use[10];
double t0;

unsigned int _seed = 1;
#define _A 1664525
#define _C 1013904223
#define RAND_MAX 0xFFFFFFFFU

unsigned int rand(void)
{
    _seed = (_A * _seed) + _C;
    return _seed;
}

float drand(void)
{
    return rand() * 1.0 / RAND_MAX;
}

    
float fast_log (float val)
{
    int *          exp_ptr = (int *)(&val);
    int            x = *exp_ptr;
    const int      log_2 = ((x >> 23) & 255) - 128;
    x &= ~(255 << 23);
    x += 127 << 23;
    *exp_ptr = x;
    val = ((-1.0f/3) * val + 2) * val - 2.0f/3;   // (1)
    return (val + log_2) * 0.69314718f;
} 

/* sleep_exp(T) - sleep for exp. dist. time with mean T msecs
 *                unlocks mutex while sleeping if provided.
 */
void sleep_exp(double T)
{
    double t = -1 * T * fast_log(drand()); /* sleep time */
    if (t > T*10)
        t = T*10;
    if (t < 0.5)
        t = 0.5;
    sleep((int)(t * 100));
}

/* get_forks() method - called before a philospher starts eating.
 *                      'i' identifies the philosopher 0..N-1
 */
void get_forks(int i)
{
    int left = i, right = (i+1) % nforks;
    qthread_mutex_lock(&m);

    printf(1,"DEBUG: %d philosopher %d tries for left fork\n", uptime(), i);
    if (fork_in_use[left]) 
        qthread_cond_wait(&C[left], &m);
    printf(1,"DEBUG: %d philosopher %d gets left fork\n", uptime(), i);
    fork_in_use[left] = 1;
    printf(1,"DEBUG: %d philosopher %d tries for right fork\n", uptime(), i);
    if (fork_in_use[right])
        qthread_cond_wait(&C[right], &m);
    printf(1,"DEBUG: %d philosopher %d gets left fork\n", uptime(), i);
    fork_in_use[right] = 1;

    qthread_mutex_unlock(&m);
}

/* release_forks()  - called when a philospher is done eating.
 *                    'i' identifies the philosopher 0..N-1
 */
void release_forks(int i)
{
    int left = i, right = (i+1) % nforks;

    qthread_mutex_lock(&m);

    printf(1,"DEBUG: %d philosopher %d puts down both forks\n", uptime(), i);
    fork_in_use[left] = 0;
    qthread_cond_signal(&C[left]);
    fork_in_use[right] = 0;
    qthread_cond_signal(&C[right]);

    qthread_mutex_unlock(&m);
}

/* the philosopher thread function - create N threads, each of which calls 
 * this function with its philosopher number 0..N-1
 */
void *philosopher_thread(void *context) 
{
    int philosopher_num = (int)context; /* hack... */

    printf(1, "phil %d stack %d\n", philosopher_num, (int)&philosopher_num);
    
    while (1) {
        sleep_exp(4.0);
        get_forks(philosopher_num);
        sleep_exp(2.5);
        release_forks(philosopher_num);
    }
    
    return 0;
}

int main(int argc, char **argv)
{
    int i;
    qthread_t t;

    nforks = 4;

    qthread_mutex_init(&m, 0);
    for (i = 0; i < nforks; i++)
        qthread_cond_init(&C[i], 0);

    for (i = 0; i < nforks; i++) 
        qthread_create(&t, philosopher_thread, (void*)i);

    sleep(10000);

    exit();
}
