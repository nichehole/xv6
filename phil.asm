
_phil:     file format elf32-i386


Disassembly of section .text:

00000000 <rand>:
#define _A 1664525
#define _C 1013904223
#define RAND_MAX 0xFFFFFFFFU

unsigned int rand(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
    _seed = (_A * _seed) + _C;
   3:	a1 30 11 00 00       	mov    0x1130,%eax
   8:	69 c0 0d 66 19 00    	imul   $0x19660d,%eax,%eax
   e:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  13:	a3 30 11 00 00       	mov    %eax,0x1130
    return _seed;
  18:	a1 30 11 00 00       	mov    0x1130,%eax
}
  1d:	5d                   	pop    %ebp
  1e:	c3                   	ret    

0000001f <drand>:

float drand(void)
{
  1f:	55                   	push   %ebp
  20:	89 e5                	mov    %esp,%ebp
  22:	83 ec 10             	sub    $0x10,%esp
    return rand() * 1.0 / RAND_MAX;
  25:	e8 d6 ff ff ff       	call   0 <rand>
  2a:	ba 00 00 00 00       	mov    $0x0,%edx
  2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  32:	89 55 f4             	mov    %edx,-0xc(%ebp)
  35:	df 6d f0             	fildll -0x10(%ebp)
  38:	dd 05 68 0d 00 00    	fldl   0xd68
  3e:	de f9                	fdivrp %st,%st(1)
  40:	d9 5d fc             	fstps  -0x4(%ebp)
  43:	d9 45 fc             	flds   -0x4(%ebp)
}
  46:	c9                   	leave  
  47:	c3                   	ret    

00000048 <fast_log>:

    
float fast_log (float val)
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	83 ec 10             	sub    $0x10,%esp
    int *          exp_ptr = (int *)(&val);
  4e:	8d 45 08             	lea    0x8(%ebp),%eax
  51:	89 45 fc             	mov    %eax,-0x4(%ebp)
    int            x = *exp_ptr;
  54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  57:	8b 00                	mov    (%eax),%eax
  59:	89 45 f8             	mov    %eax,-0x8(%ebp)
    const int      log_2 = ((x >> 23) & 255) - 128;
  5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  5f:	c1 f8 17             	sar    $0x17,%eax
  62:	0f b6 c0             	movzbl %al,%eax
  65:	83 c0 80             	add    $0xffffff80,%eax
  68:	89 45 f4             	mov    %eax,-0xc(%ebp)
    x &= ~(255 << 23);
  6b:	81 65 f8 ff ff 7f 80 	andl   $0x807fffff,-0x8(%ebp)
    x += 127 << 23;
  72:	81 45 f8 00 00 80 3f 	addl   $0x3f800000,-0x8(%ebp)
    *exp_ptr = x;
  79:	8b 45 fc             	mov    -0x4(%ebp),%eax
  7c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  7f:	89 10                	mov    %edx,(%eax)
    val = ((-1.0f/3) * val + 2) * val - 2.0f/3;   // (1)
  81:	d9 45 08             	flds   0x8(%ebp)
  84:	d9 05 70 0d 00 00    	flds   0xd70
  8a:	de c9                	fmulp  %st,%st(1)
  8c:	d9 05 74 0d 00 00    	flds   0xd74
  92:	de c1                	faddp  %st,%st(1)
  94:	d9 45 08             	flds   0x8(%ebp)
  97:	de c9                	fmulp  %st,%st(1)
  99:	d9 05 78 0d 00 00    	flds   0xd78
  9f:	de e9                	fsubrp %st,%st(1)
  a1:	d9 5d 08             	fstps  0x8(%ebp)
    return (val + log_2) * 0.69314718f;
  a4:	db 45 f4             	fildl  -0xc(%ebp)
  a7:	d9 45 08             	flds   0x8(%ebp)
  aa:	de c1                	faddp  %st,%st(1)
  ac:	d9 05 7c 0d 00 00    	flds   0xd7c
  b2:	de c9                	fmulp  %st,%st(1)
} 
  b4:	c9                   	leave  
  b5:	c3                   	ret    

000000b6 <sleep_exp>:

/* sleep_exp(T) - sleep for exp. dist. time with mean T msecs
 *                unlocks mutex while sleeping if provided.
 */
void sleep_exp(double T)
{
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	83 ec 38             	sub    $0x38,%esp
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    double t = -1 * T * fast_log(drand()); /* sleep time */
  c8:	dd 45 e0             	fldl   -0x20(%ebp)
  cb:	d9 e0                	fchs   
  cd:	dd 5d d0             	fstpl  -0x30(%ebp)
  d0:	e8 4a ff ff ff       	call   1f <drand>
  d5:	d9 1c 24             	fstps  (%esp)
  d8:	e8 6b ff ff ff       	call   48 <fast_log>
  dd:	dc 4d d0             	fmull  -0x30(%ebp)
  e0:	dd 5d f0             	fstpl  -0x10(%ebp)
    if (t > T*10)
  e3:	dd 45 e0             	fldl   -0x20(%ebp)
  e6:	dd 05 80 0d 00 00    	fldl   0xd80
  ec:	de c9                	fmulp  %st,%st(1)
  ee:	dd 45 f0             	fldl   -0x10(%ebp)
  f1:	df e9                	fucomip %st(1),%st
  f3:	dd d8                	fstp   %st(0)
  f5:	76 0e                	jbe    105 <sleep_exp+0x4f>
        t = T*10;
  f7:	dd 45 e0             	fldl   -0x20(%ebp)
  fa:	dd 05 80 0d 00 00    	fldl   0xd80
 100:	de c9                	fmulp  %st,%st(1)
 102:	dd 5d f0             	fstpl  -0x10(%ebp)
    if (t < 0.5)
 105:	dd 05 88 0d 00 00    	fldl   0xd88
 10b:	dd 45 f0             	fldl   -0x10(%ebp)
 10e:	d9 c9                	fxch   %st(1)
 110:	df e9                	fucomip %st(1),%st
 112:	dd d8                	fstp   %st(0)
 114:	76 09                	jbe    11f <sleep_exp+0x69>
        t = 0.5;
 116:	dd 05 88 0d 00 00    	fldl   0xd88
 11c:	dd 5d f0             	fstpl  -0x10(%ebp)
    sleep((int)(t * 100));
 11f:	dd 45 f0             	fldl   -0x10(%ebp)
 122:	dd 05 90 0d 00 00    	fldl   0xd90
 128:	de c9                	fmulp  %st,%st(1)
 12a:	d9 7d de             	fnstcw -0x22(%ebp)
 12d:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
 131:	b4 0c                	mov    $0xc,%ah
 133:	66 89 45 dc          	mov    %ax,-0x24(%ebp)
 137:	d9 6d dc             	fldcw  -0x24(%ebp)
 13a:	db 5d d8             	fistpl -0x28(%ebp)
 13d:	d9 6d de             	fldcw  -0x22(%ebp)
 140:	8b 45 d8             	mov    -0x28(%ebp),%eax
 143:	89 04 24             	mov    %eax,(%esp)
 146:	e8 14 06 00 00       	call   75f <sleep>
}
 14b:	c9                   	leave  
 14c:	c3                   	ret    

0000014d <get_forks>:

/* get_forks() method - called before a philospher starts eating.
 *                      'i' identifies the philosopher 0..N-1
 */
void get_forks(int i)
{
 14d:	55                   	push   %ebp
 14e:	89 e5                	mov    %esp,%ebp
 150:	83 ec 28             	sub    $0x28,%esp
    int left = i, right = (i+1) % nforks;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	89 45 f4             	mov    %eax,-0xc(%ebp)
 159:	8b 45 08             	mov    0x8(%ebp),%eax
 15c:	83 c0 01             	add    $0x1,%eax
 15f:	8b 0d 80 11 00 00    	mov    0x1180,%ecx
 165:	99                   	cltd   
 166:	f7 f9                	idiv   %ecx
 168:	89 55 f0             	mov    %edx,-0x10(%ebp)
    qthread_mutex_lock(&m);
 16b:	c7 44 24 04 30 12 00 	movl   $0x1230,0x4(%esp)
 172:	00 
 173:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
 17a:	e8 f0 05 00 00       	call   76f <threadop>

    printf(1,"DEBUG: %d philosopher %d tries for left fork\n", uptime(), i);
 17f:	e8 e3 05 00 00       	call   767 <uptime>
 184:	8b 55 08             	mov    0x8(%ebp),%edx
 187:	89 54 24 0c          	mov    %edx,0xc(%esp)
 18b:	89 44 24 08          	mov    %eax,0x8(%esp)
 18f:	c7 44 24 04 98 0c 00 	movl   $0xc98,0x4(%esp)
 196:	00 
 197:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 19e:	e8 b4 06 00 00       	call   857 <printf>
    if (fork_in_use[left]) 
 1a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a6:	8b 04 85 00 12 00 00 	mov    0x1200(,%eax,4),%eax
 1ad:	85 c0                	test   %eax,%eax
 1af:	74 23                	je     1d4 <get_forks+0x87>
        qthread_cond_wait(&C[left], &m);
 1b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b4:	c1 e0 03             	shl    $0x3,%eax
 1b7:	05 a0 11 00 00       	add    $0x11a0,%eax
 1bc:	c7 44 24 08 30 12 00 	movl   $0x1230,0x8(%esp)
 1c3:	00 
 1c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c8:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1cf:	e8 9b 05 00 00       	call   76f <threadop>
    printf(1,"DEBUG: %d philosopher %d gets left fork\n", uptime(), i);
 1d4:	e8 8e 05 00 00       	call   767 <uptime>
 1d9:	8b 55 08             	mov    0x8(%ebp),%edx
 1dc:	89 54 24 0c          	mov    %edx,0xc(%esp)
 1e0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e4:	c7 44 24 04 c8 0c 00 	movl   $0xcc8,0x4(%esp)
 1eb:	00 
 1ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1f3:	e8 5f 06 00 00       	call   857 <printf>
    fork_in_use[left] = 1;
 1f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fb:	c7 04 85 00 12 00 00 	movl   $0x1,0x1200(,%eax,4)
 202:	01 00 00 00 
    printf(1,"DEBUG: %d philosopher %d tries for right fork\n", uptime(), i);
 206:	e8 5c 05 00 00       	call   767 <uptime>
 20b:	8b 55 08             	mov    0x8(%ebp),%edx
 20e:	89 54 24 0c          	mov    %edx,0xc(%esp)
 212:	89 44 24 08          	mov    %eax,0x8(%esp)
 216:	c7 44 24 04 f4 0c 00 	movl   $0xcf4,0x4(%esp)
 21d:	00 
 21e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 225:	e8 2d 06 00 00       	call   857 <printf>
    if (fork_in_use[right])
 22a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 22d:	8b 04 85 00 12 00 00 	mov    0x1200(,%eax,4),%eax
 234:	85 c0                	test   %eax,%eax
 236:	74 23                	je     25b <get_forks+0x10e>
        qthread_cond_wait(&C[right], &m);
 238:	8b 45 f0             	mov    -0x10(%ebp),%eax
 23b:	c1 e0 03             	shl    $0x3,%eax
 23e:	05 a0 11 00 00       	add    $0x11a0,%eax
 243:	c7 44 24 08 30 12 00 	movl   $0x1230,0x8(%esp)
 24a:	00 
 24b:	89 44 24 04          	mov    %eax,0x4(%esp)
 24f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 256:	e8 14 05 00 00       	call   76f <threadop>
    printf(1,"DEBUG: %d philosopher %d gets left fork\n", uptime(), i);
 25b:	e8 07 05 00 00       	call   767 <uptime>
 260:	8b 55 08             	mov    0x8(%ebp),%edx
 263:	89 54 24 0c          	mov    %edx,0xc(%esp)
 267:	89 44 24 08          	mov    %eax,0x8(%esp)
 26b:	c7 44 24 04 c8 0c 00 	movl   $0xcc8,0x4(%esp)
 272:	00 
 273:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 27a:	e8 d8 05 00 00       	call   857 <printf>
    fork_in_use[right] = 1;
 27f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 282:	c7 04 85 00 12 00 00 	movl   $0x1,0x1200(,%eax,4)
 289:	01 00 00 00 

    qthread_mutex_unlock(&m);
 28d:	c7 44 24 04 30 12 00 	movl   $0x1230,0x4(%esp)
 294:	00 
 295:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 29c:	e8 ce 04 00 00       	call   76f <threadop>
}
 2a1:	c9                   	leave  
 2a2:	c3                   	ret    

000002a3 <release_forks>:

/* release_forks()  - called when a philospher is done eating.
 *                    'i' identifies the philosopher 0..N-1
 */
void release_forks(int i)
{
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
 2a6:	83 ec 28             	sub    $0x28,%esp
    int left = i, right = (i+1) % nforks;
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
 2b2:	83 c0 01             	add    $0x1,%eax
 2b5:	8b 0d 80 11 00 00    	mov    0x1180,%ecx
 2bb:	99                   	cltd   
 2bc:	f7 f9                	idiv   %ecx
 2be:	89 55 f0             	mov    %edx,-0x10(%ebp)

    qthread_mutex_lock(&m);
 2c1:	c7 44 24 04 30 12 00 	movl   $0x1230,0x4(%esp)
 2c8:	00 
 2c9:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
 2d0:	e8 9a 04 00 00       	call   76f <threadop>

    printf(1,"DEBUG: %d philosopher %d puts down both forks\n", uptime(), i);
 2d5:	e8 8d 04 00 00       	call   767 <uptime>
 2da:	8b 55 08             	mov    0x8(%ebp),%edx
 2dd:	89 54 24 0c          	mov    %edx,0xc(%esp)
 2e1:	89 44 24 08          	mov    %eax,0x8(%esp)
 2e5:	c7 44 24 04 24 0d 00 	movl   $0xd24,0x4(%esp)
 2ec:	00 
 2ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2f4:	e8 5e 05 00 00       	call   857 <printf>
    fork_in_use[left] = 0;
 2f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2fc:	c7 04 85 00 12 00 00 	movl   $0x0,0x1200(,%eax,4)
 303:	00 00 00 00 
    qthread_cond_signal(&C[left]);
 307:	8b 45 f4             	mov    -0xc(%ebp),%eax
 30a:	c1 e0 03             	shl    $0x3,%eax
 30d:	05 a0 11 00 00       	add    $0x11a0,%eax
 312:	89 44 24 04          	mov    %eax,0x4(%esp)
 316:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
 31d:	e8 4d 04 00 00       	call   76f <threadop>
    fork_in_use[right] = 0;
 322:	8b 45 f0             	mov    -0x10(%ebp),%eax
 325:	c7 04 85 00 12 00 00 	movl   $0x0,0x1200(,%eax,4)
 32c:	00 00 00 00 
    qthread_cond_signal(&C[right]);
 330:	8b 45 f0             	mov    -0x10(%ebp),%eax
 333:	c1 e0 03             	shl    $0x3,%eax
 336:	05 a0 11 00 00       	add    $0x11a0,%eax
 33b:	89 44 24 04          	mov    %eax,0x4(%esp)
 33f:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
 346:	e8 24 04 00 00       	call   76f <threadop>

    qthread_mutex_unlock(&m);
 34b:	c7 44 24 04 30 12 00 	movl   $0x1230,0x4(%esp)
 352:	00 
 353:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 35a:	e8 10 04 00 00       	call   76f <threadop>
}
 35f:	c9                   	leave  
 360:	c3                   	ret    

00000361 <philosopher_thread>:

/* the philosopher thread function - create N threads, each of which calls 
 * this function with its philosopher number 0..N-1
 */
void *philosopher_thread(void *context) 
{
 361:	55                   	push   %ebp
 362:	89 e5                	mov    %esp,%ebp
 364:	83 ec 28             	sub    $0x28,%esp
    int philosopher_num = (int)context; /* hack... */
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	89 45 f4             	mov    %eax,-0xc(%ebp)

    printf(1, "phil %d stack %d\n", philosopher_num, (int)&philosopher_num);
 36d:	8d 55 f4             	lea    -0xc(%ebp),%edx
 370:	8b 45 f4             	mov    -0xc(%ebp),%eax
 373:	89 54 24 0c          	mov    %edx,0xc(%esp)
 377:	89 44 24 08          	mov    %eax,0x8(%esp)
 37b:	c7 44 24 04 53 0d 00 	movl   $0xd53,0x4(%esp)
 382:	00 
 383:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 38a:	e8 c8 04 00 00       	call   857 <printf>
    
    while (1) {
        sleep_exp(4.0);
 38f:	dd 05 98 0d 00 00    	fldl   0xd98
 395:	dd 1c 24             	fstpl  (%esp)
 398:	e8 19 fd ff ff       	call   b6 <sleep_exp>
        get_forks(philosopher_num);
 39d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a0:	89 04 24             	mov    %eax,(%esp)
 3a3:	e8 a5 fd ff ff       	call   14d <get_forks>
        sleep_exp(2.5);
 3a8:	dd 05 a0 0d 00 00    	fldl   0xda0
 3ae:	dd 1c 24             	fstpl  (%esp)
 3b1:	e8 00 fd ff ff       	call   b6 <sleep_exp>
        release_forks(philosopher_num);
 3b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3b9:	89 04 24             	mov    %eax,(%esp)
 3bc:	e8 e2 fe ff ff       	call   2a3 <release_forks>
    }
 3c1:	eb cc                	jmp    38f <philosopher_thread+0x2e>

000003c3 <main>:
    
    return 0;
}

int main(int argc, char **argv)
{
 3c3:	55                   	push   %ebp
 3c4:	89 e5                	mov    %esp,%ebp
 3c6:	83 e4 f0             	and    $0xfffffff0,%esp
 3c9:	83 ec 20             	sub    $0x20,%esp
    int i;
    qthread_t t;

    nforks = 4;
 3cc:	c7 05 80 11 00 00 04 	movl   $0x4,0x1180
 3d3:	00 00 00 

    qthread_mutex_init(&m, 0);
 3d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 3dd:	00 
 3de:	c7 04 24 30 12 00 00 	movl   $0x1230,(%esp)
 3e5:	e8 7d 08 00 00       	call   c67 <qthread_mutex_init>
    for (i = 0; i < nforks; i++)
 3ea:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 3f1:	00 
 3f2:	eb 21                	jmp    415 <main+0x52>
        qthread_cond_init(&C[i], 0);
 3f4:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 3f8:	c1 e0 03             	shl    $0x3,%eax
 3fb:	05 a0 11 00 00       	add    $0x11a0,%eax
 400:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 407:	00 
 408:	89 04 24             	mov    %eax,(%esp)
 40b:	e8 6a 08 00 00       	call   c7a <qthread_cond_init>
    qthread_t t;

    nforks = 4;

    qthread_mutex_init(&m, 0);
    for (i = 0; i < nforks; i++)
 410:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 415:	a1 80 11 00 00       	mov    0x1180,%eax
 41a:	39 44 24 1c          	cmp    %eax,0x1c(%esp)
 41e:	7c d4                	jl     3f4 <main+0x31>
        qthread_cond_init(&C[i], 0);

    for (i = 0; i < nforks; i++) 
 420:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 427:	00 
 428:	eb 21                	jmp    44b <main+0x88>
        qthread_create(&t, philosopher_thread, (void*)i);
 42a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 42e:	89 44 24 08          	mov    %eax,0x8(%esp)
 432:	c7 44 24 04 61 03 00 	movl   $0x361,0x4(%esp)
 439:	00 
 43a:	8d 44 24 18          	lea    0x18(%esp),%eax
 43e:	89 04 24             	mov    %eax,(%esp)
 441:	e8 dd 07 00 00       	call   c23 <qthread_create>

    qthread_mutex_init(&m, 0);
    for (i = 0; i < nforks; i++)
        qthread_cond_init(&C[i], 0);

    for (i = 0; i < nforks; i++) 
 446:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 44b:	a1 80 11 00 00       	mov    0x1180,%eax
 450:	39 44 24 1c          	cmp    %eax,0x1c(%esp)
 454:	7c d4                	jl     42a <main+0x67>
        qthread_create(&t, philosopher_thread, (void*)i);

    sleep(10000);
 456:	c7 04 24 10 27 00 00 	movl   $0x2710,(%esp)
 45d:	e8 fd 02 00 00       	call   75f <sleep>

    exit();
 462:	e8 68 02 00 00       	call   6cf <exit>

00000467 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 467:	55                   	push   %ebp
 468:	89 e5                	mov    %esp,%ebp
 46a:	57                   	push   %edi
 46b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 46c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 46f:	8b 55 10             	mov    0x10(%ebp),%edx
 472:	8b 45 0c             	mov    0xc(%ebp),%eax
 475:	89 cb                	mov    %ecx,%ebx
 477:	89 df                	mov    %ebx,%edi
 479:	89 d1                	mov    %edx,%ecx
 47b:	fc                   	cld    
 47c:	f3 aa                	rep stos %al,%es:(%edi)
 47e:	89 ca                	mov    %ecx,%edx
 480:	89 fb                	mov    %edi,%ebx
 482:	89 5d 08             	mov    %ebx,0x8(%ebp)
 485:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 488:	5b                   	pop    %ebx
 489:	5f                   	pop    %edi
 48a:	5d                   	pop    %ebp
 48b:	c3                   	ret    

0000048c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 48c:	55                   	push   %ebp
 48d:	89 e5                	mov    %esp,%ebp
 48f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 492:	8b 45 08             	mov    0x8(%ebp),%eax
 495:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 498:	90                   	nop
 499:	8b 45 08             	mov    0x8(%ebp),%eax
 49c:	8d 50 01             	lea    0x1(%eax),%edx
 49f:	89 55 08             	mov    %edx,0x8(%ebp)
 4a2:	8b 55 0c             	mov    0xc(%ebp),%edx
 4a5:	8d 4a 01             	lea    0x1(%edx),%ecx
 4a8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 4ab:	0f b6 12             	movzbl (%edx),%edx
 4ae:	88 10                	mov    %dl,(%eax)
 4b0:	0f b6 00             	movzbl (%eax),%eax
 4b3:	84 c0                	test   %al,%al
 4b5:	75 e2                	jne    499 <strcpy+0xd>
    ;
  return os;
 4b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4ba:	c9                   	leave  
 4bb:	c3                   	ret    

000004bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4bc:	55                   	push   %ebp
 4bd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 4bf:	eb 08                	jmp    4c9 <strcmp+0xd>
    p++, q++;
 4c1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4c5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 4c9:	8b 45 08             	mov    0x8(%ebp),%eax
 4cc:	0f b6 00             	movzbl (%eax),%eax
 4cf:	84 c0                	test   %al,%al
 4d1:	74 10                	je     4e3 <strcmp+0x27>
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	0f b6 10             	movzbl (%eax),%edx
 4d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4dc:	0f b6 00             	movzbl (%eax),%eax
 4df:	38 c2                	cmp    %al,%dl
 4e1:	74 de                	je     4c1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
 4e6:	0f b6 00             	movzbl (%eax),%eax
 4e9:	0f b6 d0             	movzbl %al,%edx
 4ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ef:	0f b6 00             	movzbl (%eax),%eax
 4f2:	0f b6 c0             	movzbl %al,%eax
 4f5:	29 c2                	sub    %eax,%edx
 4f7:	89 d0                	mov    %edx,%eax
}
 4f9:	5d                   	pop    %ebp
 4fa:	c3                   	ret    

000004fb <strlen>:

uint
strlen(char *s)
{
 4fb:	55                   	push   %ebp
 4fc:	89 e5                	mov    %esp,%ebp
 4fe:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 501:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 508:	eb 04                	jmp    50e <strlen+0x13>
 50a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 50e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 511:	8b 45 08             	mov    0x8(%ebp),%eax
 514:	01 d0                	add    %edx,%eax
 516:	0f b6 00             	movzbl (%eax),%eax
 519:	84 c0                	test   %al,%al
 51b:	75 ed                	jne    50a <strlen+0xf>
    ;
  return n;
 51d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 520:	c9                   	leave  
 521:	c3                   	ret    

00000522 <memset>:

void*
memset(void *dst, int c, uint n)
{
 522:	55                   	push   %ebp
 523:	89 e5                	mov    %esp,%ebp
 525:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 528:	8b 45 10             	mov    0x10(%ebp),%eax
 52b:	89 44 24 08          	mov    %eax,0x8(%esp)
 52f:	8b 45 0c             	mov    0xc(%ebp),%eax
 532:	89 44 24 04          	mov    %eax,0x4(%esp)
 536:	8b 45 08             	mov    0x8(%ebp),%eax
 539:	89 04 24             	mov    %eax,(%esp)
 53c:	e8 26 ff ff ff       	call   467 <stosb>
  return dst;
 541:	8b 45 08             	mov    0x8(%ebp),%eax
}
 544:	c9                   	leave  
 545:	c3                   	ret    

00000546 <strchr>:

char*
strchr(const char *s, char c)
{
 546:	55                   	push   %ebp
 547:	89 e5                	mov    %esp,%ebp
 549:	83 ec 04             	sub    $0x4,%esp
 54c:	8b 45 0c             	mov    0xc(%ebp),%eax
 54f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 552:	eb 14                	jmp    568 <strchr+0x22>
    if(*s == c)
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	0f b6 00             	movzbl (%eax),%eax
 55a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 55d:	75 05                	jne    564 <strchr+0x1e>
      return (char*)s;
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	eb 13                	jmp    577 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 564:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 568:	8b 45 08             	mov    0x8(%ebp),%eax
 56b:	0f b6 00             	movzbl (%eax),%eax
 56e:	84 c0                	test   %al,%al
 570:	75 e2                	jne    554 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 572:	b8 00 00 00 00       	mov    $0x0,%eax
}
 577:	c9                   	leave  
 578:	c3                   	ret    

00000579 <gets>:

char*
gets(char *buf, int max)
{
 579:	55                   	push   %ebp
 57a:	89 e5                	mov    %esp,%ebp
 57c:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 57f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 586:	eb 4c                	jmp    5d4 <gets+0x5b>
    cc = read(0, &c, 1);
 588:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 58f:	00 
 590:	8d 45 ef             	lea    -0x11(%ebp),%eax
 593:	89 44 24 04          	mov    %eax,0x4(%esp)
 597:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 59e:	e8 44 01 00 00       	call   6e7 <read>
 5a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 5a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5aa:	7f 02                	jg     5ae <gets+0x35>
      break;
 5ac:	eb 31                	jmp    5df <gets+0x66>
    buf[i++] = c;
 5ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b1:	8d 50 01             	lea    0x1(%eax),%edx
 5b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5b7:	89 c2                	mov    %eax,%edx
 5b9:	8b 45 08             	mov    0x8(%ebp),%eax
 5bc:	01 c2                	add    %eax,%edx
 5be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 5c2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 5c4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 5c8:	3c 0a                	cmp    $0xa,%al
 5ca:	74 13                	je     5df <gets+0x66>
 5cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 5d0:	3c 0d                	cmp    $0xd,%al
 5d2:	74 0b                	je     5df <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d7:	83 c0 01             	add    $0x1,%eax
 5da:	3b 45 0c             	cmp    0xc(%ebp),%eax
 5dd:	7c a9                	jl     588 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 5df:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5e2:	8b 45 08             	mov    0x8(%ebp),%eax
 5e5:	01 d0                	add    %edx,%eax
 5e7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 5ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5ed:	c9                   	leave  
 5ee:	c3                   	ret    

000005ef <stat>:

int
stat(char *n, struct stat *st)
{
 5ef:	55                   	push   %ebp
 5f0:	89 e5                	mov    %esp,%ebp
 5f2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 5fc:	00 
 5fd:	8b 45 08             	mov    0x8(%ebp),%eax
 600:	89 04 24             	mov    %eax,(%esp)
 603:	e8 07 01 00 00       	call   70f <open>
 608:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 60b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 60f:	79 07                	jns    618 <stat+0x29>
    return -1;
 611:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 616:	eb 23                	jmp    63b <stat+0x4c>
  r = fstat(fd, st);
 618:	8b 45 0c             	mov    0xc(%ebp),%eax
 61b:	89 44 24 04          	mov    %eax,0x4(%esp)
 61f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 622:	89 04 24             	mov    %eax,(%esp)
 625:	e8 fd 00 00 00       	call   727 <fstat>
 62a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 62d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 630:	89 04 24             	mov    %eax,(%esp)
 633:	e8 bf 00 00 00       	call   6f7 <close>
  return r;
 638:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 63b:	c9                   	leave  
 63c:	c3                   	ret    

0000063d <atoi>:

int
atoi(const char *s)
{
 63d:	55                   	push   %ebp
 63e:	89 e5                	mov    %esp,%ebp
 640:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 643:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 64a:	eb 25                	jmp    671 <atoi+0x34>
    n = n*10 + *s++ - '0';
 64c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 64f:	89 d0                	mov    %edx,%eax
 651:	c1 e0 02             	shl    $0x2,%eax
 654:	01 d0                	add    %edx,%eax
 656:	01 c0                	add    %eax,%eax
 658:	89 c1                	mov    %eax,%ecx
 65a:	8b 45 08             	mov    0x8(%ebp),%eax
 65d:	8d 50 01             	lea    0x1(%eax),%edx
 660:	89 55 08             	mov    %edx,0x8(%ebp)
 663:	0f b6 00             	movzbl (%eax),%eax
 666:	0f be c0             	movsbl %al,%eax
 669:	01 c8                	add    %ecx,%eax
 66b:	83 e8 30             	sub    $0x30,%eax
 66e:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 671:	8b 45 08             	mov    0x8(%ebp),%eax
 674:	0f b6 00             	movzbl (%eax),%eax
 677:	3c 2f                	cmp    $0x2f,%al
 679:	7e 0a                	jle    685 <atoi+0x48>
 67b:	8b 45 08             	mov    0x8(%ebp),%eax
 67e:	0f b6 00             	movzbl (%eax),%eax
 681:	3c 39                	cmp    $0x39,%al
 683:	7e c7                	jle    64c <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 685:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 688:	c9                   	leave  
 689:	c3                   	ret    

0000068a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 68a:	55                   	push   %ebp
 68b:	89 e5                	mov    %esp,%ebp
 68d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 690:	8b 45 08             	mov    0x8(%ebp),%eax
 693:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 696:	8b 45 0c             	mov    0xc(%ebp),%eax
 699:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 69c:	eb 17                	jmp    6b5 <memmove+0x2b>
    *dst++ = *src++;
 69e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a1:	8d 50 01             	lea    0x1(%eax),%edx
 6a4:	89 55 fc             	mov    %edx,-0x4(%ebp)
 6a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6aa:	8d 4a 01             	lea    0x1(%edx),%ecx
 6ad:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 6b0:	0f b6 12             	movzbl (%edx),%edx
 6b3:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6b5:	8b 45 10             	mov    0x10(%ebp),%eax
 6b8:	8d 50 ff             	lea    -0x1(%eax),%edx
 6bb:	89 55 10             	mov    %edx,0x10(%ebp)
 6be:	85 c0                	test   %eax,%eax
 6c0:	7f dc                	jg     69e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 6c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6c5:	c9                   	leave  
 6c6:	c3                   	ret    

000006c7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 6c7:	b8 01 00 00 00       	mov    $0x1,%eax
 6cc:	cd 40                	int    $0x40
 6ce:	c3                   	ret    

000006cf <exit>:
SYSCALL(exit)
 6cf:	b8 02 00 00 00       	mov    $0x2,%eax
 6d4:	cd 40                	int    $0x40
 6d6:	c3                   	ret    

000006d7 <wait>:
SYSCALL(wait)
 6d7:	b8 03 00 00 00       	mov    $0x3,%eax
 6dc:	cd 40                	int    $0x40
 6de:	c3                   	ret    

000006df <pipe>:
SYSCALL(pipe)
 6df:	b8 04 00 00 00       	mov    $0x4,%eax
 6e4:	cd 40                	int    $0x40
 6e6:	c3                   	ret    

000006e7 <read>:
SYSCALL(read)
 6e7:	b8 05 00 00 00       	mov    $0x5,%eax
 6ec:	cd 40                	int    $0x40
 6ee:	c3                   	ret    

000006ef <write>:
SYSCALL(write)
 6ef:	b8 10 00 00 00       	mov    $0x10,%eax
 6f4:	cd 40                	int    $0x40
 6f6:	c3                   	ret    

000006f7 <close>:
SYSCALL(close)
 6f7:	b8 15 00 00 00       	mov    $0x15,%eax
 6fc:	cd 40                	int    $0x40
 6fe:	c3                   	ret    

000006ff <kill>:
SYSCALL(kill)
 6ff:	b8 06 00 00 00       	mov    $0x6,%eax
 704:	cd 40                	int    $0x40
 706:	c3                   	ret    

00000707 <exec>:
SYSCALL(exec)
 707:	b8 07 00 00 00       	mov    $0x7,%eax
 70c:	cd 40                	int    $0x40
 70e:	c3                   	ret    

0000070f <open>:
SYSCALL(open)
 70f:	b8 0f 00 00 00       	mov    $0xf,%eax
 714:	cd 40                	int    $0x40
 716:	c3                   	ret    

00000717 <mknod>:
SYSCALL(mknod)
 717:	b8 11 00 00 00       	mov    $0x11,%eax
 71c:	cd 40                	int    $0x40
 71e:	c3                   	ret    

0000071f <unlink>:
SYSCALL(unlink)
 71f:	b8 12 00 00 00       	mov    $0x12,%eax
 724:	cd 40                	int    $0x40
 726:	c3                   	ret    

00000727 <fstat>:
SYSCALL(fstat)
 727:	b8 08 00 00 00       	mov    $0x8,%eax
 72c:	cd 40                	int    $0x40
 72e:	c3                   	ret    

0000072f <link>:
SYSCALL(link)
 72f:	b8 13 00 00 00       	mov    $0x13,%eax
 734:	cd 40                	int    $0x40
 736:	c3                   	ret    

00000737 <mkdir>:
SYSCALL(mkdir)
 737:	b8 14 00 00 00       	mov    $0x14,%eax
 73c:	cd 40                	int    $0x40
 73e:	c3                   	ret    

0000073f <chdir>:
SYSCALL(chdir)
 73f:	b8 09 00 00 00       	mov    $0x9,%eax
 744:	cd 40                	int    $0x40
 746:	c3                   	ret    

00000747 <dup>:
SYSCALL(dup)
 747:	b8 0a 00 00 00       	mov    $0xa,%eax
 74c:	cd 40                	int    $0x40
 74e:	c3                   	ret    

0000074f <getpid>:
SYSCALL(getpid)
 74f:	b8 0b 00 00 00       	mov    $0xb,%eax
 754:	cd 40                	int    $0x40
 756:	c3                   	ret    

00000757 <sbrk>:
SYSCALL(sbrk)
 757:	b8 0c 00 00 00       	mov    $0xc,%eax
 75c:	cd 40                	int    $0x40
 75e:	c3                   	ret    

0000075f <sleep>:
SYSCALL(sleep)
 75f:	b8 0d 00 00 00       	mov    $0xd,%eax
 764:	cd 40                	int    $0x40
 766:	c3                   	ret    

00000767 <uptime>:
SYSCALL(uptime)
 767:	b8 0e 00 00 00       	mov    $0xe,%eax
 76c:	cd 40                	int    $0x40
 76e:	c3                   	ret    

0000076f <threadop>:
SYSCALL(threadop)
 76f:	b8 16 00 00 00       	mov    $0x16,%eax
 774:	cd 40                	int    $0x40
 776:	c3                   	ret    

00000777 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 777:	55                   	push   %ebp
 778:	89 e5                	mov    %esp,%ebp
 77a:	83 ec 18             	sub    $0x18,%esp
 77d:	8b 45 0c             	mov    0xc(%ebp),%eax
 780:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 783:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 78a:	00 
 78b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 78e:	89 44 24 04          	mov    %eax,0x4(%esp)
 792:	8b 45 08             	mov    0x8(%ebp),%eax
 795:	89 04 24             	mov    %eax,(%esp)
 798:	e8 52 ff ff ff       	call   6ef <write>
}
 79d:	c9                   	leave  
 79e:	c3                   	ret    

0000079f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 79f:	55                   	push   %ebp
 7a0:	89 e5                	mov    %esp,%ebp
 7a2:	56                   	push   %esi
 7a3:	53                   	push   %ebx
 7a4:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7ae:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7b2:	74 17                	je     7cb <printint+0x2c>
 7b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7b8:	79 11                	jns    7cb <printint+0x2c>
    neg = 1;
 7ba:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 7c4:	f7 d8                	neg    %eax
 7c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7c9:	eb 06                	jmp    7d1 <printint+0x32>
  } else {
    x = xx;
 7cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 7ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7d8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 7db:	8d 41 01             	lea    0x1(%ecx),%eax
 7de:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7e1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e7:	ba 00 00 00 00       	mov    $0x0,%edx
 7ec:	f7 f3                	div    %ebx
 7ee:	89 d0                	mov    %edx,%eax
 7f0:	0f b6 80 34 11 00 00 	movzbl 0x1134(%eax),%eax
 7f7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 7fb:	8b 75 10             	mov    0x10(%ebp),%esi
 7fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
 801:	ba 00 00 00 00       	mov    $0x0,%edx
 806:	f7 f6                	div    %esi
 808:	89 45 ec             	mov    %eax,-0x14(%ebp)
 80b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 80f:	75 c7                	jne    7d8 <printint+0x39>
  if(neg)
 811:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 815:	74 10                	je     827 <printint+0x88>
    buf[i++] = '-';
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	8d 50 01             	lea    0x1(%eax),%edx
 81d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 820:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 825:	eb 1f                	jmp    846 <printint+0xa7>
 827:	eb 1d                	jmp    846 <printint+0xa7>
    putc(fd, buf[i]);
 829:	8d 55 dc             	lea    -0x24(%ebp),%edx
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	01 d0                	add    %edx,%eax
 831:	0f b6 00             	movzbl (%eax),%eax
 834:	0f be c0             	movsbl %al,%eax
 837:	89 44 24 04          	mov    %eax,0x4(%esp)
 83b:	8b 45 08             	mov    0x8(%ebp),%eax
 83e:	89 04 24             	mov    %eax,(%esp)
 841:	e8 31 ff ff ff       	call   777 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 846:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 84a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 84e:	79 d9                	jns    829 <printint+0x8a>
    putc(fd, buf[i]);
}
 850:	83 c4 30             	add    $0x30,%esp
 853:	5b                   	pop    %ebx
 854:	5e                   	pop    %esi
 855:	5d                   	pop    %ebp
 856:	c3                   	ret    

00000857 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 857:	55                   	push   %ebp
 858:	89 e5                	mov    %esp,%ebp
 85a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 85d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 864:	8d 45 0c             	lea    0xc(%ebp),%eax
 867:	83 c0 04             	add    $0x4,%eax
 86a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 86d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 874:	e9 7c 01 00 00       	jmp    9f5 <printf+0x19e>
    c = fmt[i] & 0xff;
 879:	8b 55 0c             	mov    0xc(%ebp),%edx
 87c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87f:	01 d0                	add    %edx,%eax
 881:	0f b6 00             	movzbl (%eax),%eax
 884:	0f be c0             	movsbl %al,%eax
 887:	25 ff 00 00 00       	and    $0xff,%eax
 88c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 88f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 893:	75 2c                	jne    8c1 <printf+0x6a>
      if(c == '%'){
 895:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 899:	75 0c                	jne    8a7 <printf+0x50>
        state = '%';
 89b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8a2:	e9 4a 01 00 00       	jmp    9f1 <printf+0x19a>
      } else {
        putc(fd, c);
 8a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8aa:	0f be c0             	movsbl %al,%eax
 8ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 8b1:	8b 45 08             	mov    0x8(%ebp),%eax
 8b4:	89 04 24             	mov    %eax,(%esp)
 8b7:	e8 bb fe ff ff       	call   777 <putc>
 8bc:	e9 30 01 00 00       	jmp    9f1 <printf+0x19a>
      }
    } else if(state == '%'){
 8c1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8c5:	0f 85 26 01 00 00    	jne    9f1 <printf+0x19a>
      if(c == 'd'){
 8cb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8cf:	75 2d                	jne    8fe <printf+0xa7>
        printint(fd, *ap, 10, 1);
 8d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8d4:	8b 00                	mov    (%eax),%eax
 8d6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8dd:	00 
 8de:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 8e5:	00 
 8e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ea:	8b 45 08             	mov    0x8(%ebp),%eax
 8ed:	89 04 24             	mov    %eax,(%esp)
 8f0:	e8 aa fe ff ff       	call   79f <printint>
        ap++;
 8f5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8f9:	e9 ec 00 00 00       	jmp    9ea <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 8fe:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 902:	74 06                	je     90a <printf+0xb3>
 904:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 908:	75 2d                	jne    937 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 90a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 90d:	8b 00                	mov    (%eax),%eax
 90f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 916:	00 
 917:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 91e:	00 
 91f:	89 44 24 04          	mov    %eax,0x4(%esp)
 923:	8b 45 08             	mov    0x8(%ebp),%eax
 926:	89 04 24             	mov    %eax,(%esp)
 929:	e8 71 fe ff ff       	call   79f <printint>
        ap++;
 92e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 932:	e9 b3 00 00 00       	jmp    9ea <printf+0x193>
      } else if(c == 's'){
 937:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 93b:	75 45                	jne    982 <printf+0x12b>
        s = (char*)*ap;
 93d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 940:	8b 00                	mov    (%eax),%eax
 942:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 945:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 949:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 94d:	75 09                	jne    958 <printf+0x101>
          s = "(null)";
 94f:	c7 45 f4 a8 0d 00 00 	movl   $0xda8,-0xc(%ebp)
        while(*s != 0){
 956:	eb 1e                	jmp    976 <printf+0x11f>
 958:	eb 1c                	jmp    976 <printf+0x11f>
          putc(fd, *s);
 95a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95d:	0f b6 00             	movzbl (%eax),%eax
 960:	0f be c0             	movsbl %al,%eax
 963:	89 44 24 04          	mov    %eax,0x4(%esp)
 967:	8b 45 08             	mov    0x8(%ebp),%eax
 96a:	89 04 24             	mov    %eax,(%esp)
 96d:	e8 05 fe ff ff       	call   777 <putc>
          s++;
 972:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 976:	8b 45 f4             	mov    -0xc(%ebp),%eax
 979:	0f b6 00             	movzbl (%eax),%eax
 97c:	84 c0                	test   %al,%al
 97e:	75 da                	jne    95a <printf+0x103>
 980:	eb 68                	jmp    9ea <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 982:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 986:	75 1d                	jne    9a5 <printf+0x14e>
        putc(fd, *ap);
 988:	8b 45 e8             	mov    -0x18(%ebp),%eax
 98b:	8b 00                	mov    (%eax),%eax
 98d:	0f be c0             	movsbl %al,%eax
 990:	89 44 24 04          	mov    %eax,0x4(%esp)
 994:	8b 45 08             	mov    0x8(%ebp),%eax
 997:	89 04 24             	mov    %eax,(%esp)
 99a:	e8 d8 fd ff ff       	call   777 <putc>
        ap++;
 99f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9a3:	eb 45                	jmp    9ea <printf+0x193>
      } else if(c == '%'){
 9a5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9a9:	75 17                	jne    9c2 <printf+0x16b>
        putc(fd, c);
 9ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9ae:	0f be c0             	movsbl %al,%eax
 9b1:	89 44 24 04          	mov    %eax,0x4(%esp)
 9b5:	8b 45 08             	mov    0x8(%ebp),%eax
 9b8:	89 04 24             	mov    %eax,(%esp)
 9bb:	e8 b7 fd ff ff       	call   777 <putc>
 9c0:	eb 28                	jmp    9ea <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9c2:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 9c9:	00 
 9ca:	8b 45 08             	mov    0x8(%ebp),%eax
 9cd:	89 04 24             	mov    %eax,(%esp)
 9d0:	e8 a2 fd ff ff       	call   777 <putc>
        putc(fd, c);
 9d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9d8:	0f be c0             	movsbl %al,%eax
 9db:	89 44 24 04          	mov    %eax,0x4(%esp)
 9df:	8b 45 08             	mov    0x8(%ebp),%eax
 9e2:	89 04 24             	mov    %eax,(%esp)
 9e5:	e8 8d fd ff ff       	call   777 <putc>
      }
      state = 0;
 9ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9f1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 9f5:	8b 55 0c             	mov    0xc(%ebp),%edx
 9f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fb:	01 d0                	add    %edx,%eax
 9fd:	0f b6 00             	movzbl (%eax),%eax
 a00:	84 c0                	test   %al,%al
 a02:	0f 85 71 fe ff ff    	jne    879 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a08:	c9                   	leave  
 a09:	c3                   	ret    

00000a0a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a0a:	55                   	push   %ebp
 a0b:	89 e5                	mov    %esp,%ebp
 a0d:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a10:	8b 45 08             	mov    0x8(%ebp),%eax
 a13:	83 e8 08             	sub    $0x8,%eax
 a16:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a19:	a1 68 11 00 00       	mov    0x1168,%eax
 a1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a21:	eb 24                	jmp    a47 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a23:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a26:	8b 00                	mov    (%eax),%eax
 a28:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a2b:	77 12                	ja     a3f <free+0x35>
 a2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a30:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a33:	77 24                	ja     a59 <free+0x4f>
 a35:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a38:	8b 00                	mov    (%eax),%eax
 a3a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a3d:	77 1a                	ja     a59 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a42:	8b 00                	mov    (%eax),%eax
 a44:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a47:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a4a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a4d:	76 d4                	jbe    a23 <free+0x19>
 a4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a52:	8b 00                	mov    (%eax),%eax
 a54:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a57:	76 ca                	jbe    a23 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a59:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a5c:	8b 40 04             	mov    0x4(%eax),%eax
 a5f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a66:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a69:	01 c2                	add    %eax,%edx
 a6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a6e:	8b 00                	mov    (%eax),%eax
 a70:	39 c2                	cmp    %eax,%edx
 a72:	75 24                	jne    a98 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a74:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a77:	8b 50 04             	mov    0x4(%eax),%edx
 a7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a7d:	8b 00                	mov    (%eax),%eax
 a7f:	8b 40 04             	mov    0x4(%eax),%eax
 a82:	01 c2                	add    %eax,%edx
 a84:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a87:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a8d:	8b 00                	mov    (%eax),%eax
 a8f:	8b 10                	mov    (%eax),%edx
 a91:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a94:	89 10                	mov    %edx,(%eax)
 a96:	eb 0a                	jmp    aa2 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a98:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9b:	8b 10                	mov    (%eax),%edx
 a9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa0:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 aa2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa5:	8b 40 04             	mov    0x4(%eax),%eax
 aa8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab2:	01 d0                	add    %edx,%eax
 ab4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ab7:	75 20                	jne    ad9 <free+0xcf>
    p->s.size += bp->s.size;
 ab9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 abc:	8b 50 04             	mov    0x4(%eax),%edx
 abf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ac2:	8b 40 04             	mov    0x4(%eax),%eax
 ac5:	01 c2                	add    %eax,%edx
 ac7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aca:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 acd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ad0:	8b 10                	mov    (%eax),%edx
 ad2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad5:	89 10                	mov    %edx,(%eax)
 ad7:	eb 08                	jmp    ae1 <free+0xd7>
  } else
    p->s.ptr = bp;
 ad9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 adc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 adf:	89 10                	mov    %edx,(%eax)
  freep = p;
 ae1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae4:	a3 68 11 00 00       	mov    %eax,0x1168
}
 ae9:	c9                   	leave  
 aea:	c3                   	ret    

00000aeb <morecore>:

static Header*
morecore(uint nu)
{
 aeb:	55                   	push   %ebp
 aec:	89 e5                	mov    %esp,%ebp
 aee:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 af1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 af8:	77 07                	ja     b01 <morecore+0x16>
    nu = 4096;
 afa:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b01:	8b 45 08             	mov    0x8(%ebp),%eax
 b04:	c1 e0 03             	shl    $0x3,%eax
 b07:	89 04 24             	mov    %eax,(%esp)
 b0a:	e8 48 fc ff ff       	call   757 <sbrk>
 b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b12:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b16:	75 07                	jne    b1f <morecore+0x34>
    return 0;
 b18:	b8 00 00 00 00       	mov    $0x0,%eax
 b1d:	eb 22                	jmp    b41 <morecore+0x56>
  hp = (Header*)p;
 b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b28:	8b 55 08             	mov    0x8(%ebp),%edx
 b2b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b31:	83 c0 08             	add    $0x8,%eax
 b34:	89 04 24             	mov    %eax,(%esp)
 b37:	e8 ce fe ff ff       	call   a0a <free>
  return freep;
 b3c:	a1 68 11 00 00       	mov    0x1168,%eax
}
 b41:	c9                   	leave  
 b42:	c3                   	ret    

00000b43 <malloc>:

void*
malloc(uint nbytes)
{
 b43:	55                   	push   %ebp
 b44:	89 e5                	mov    %esp,%ebp
 b46:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b49:	8b 45 08             	mov    0x8(%ebp),%eax
 b4c:	83 c0 07             	add    $0x7,%eax
 b4f:	c1 e8 03             	shr    $0x3,%eax
 b52:	83 c0 01             	add    $0x1,%eax
 b55:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b58:	a1 68 11 00 00       	mov    0x1168,%eax
 b5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b64:	75 23                	jne    b89 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b66:	c7 45 f0 60 11 00 00 	movl   $0x1160,-0x10(%ebp)
 b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b70:	a3 68 11 00 00       	mov    %eax,0x1168
 b75:	a1 68 11 00 00       	mov    0x1168,%eax
 b7a:	a3 60 11 00 00       	mov    %eax,0x1160
    base.s.size = 0;
 b7f:	c7 05 64 11 00 00 00 	movl   $0x0,0x1164
 b86:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b8c:	8b 00                	mov    (%eax),%eax
 b8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b94:	8b 40 04             	mov    0x4(%eax),%eax
 b97:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b9a:	72 4d                	jb     be9 <malloc+0xa6>
      if(p->s.size == nunits)
 b9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9f:	8b 40 04             	mov    0x4(%eax),%eax
 ba2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ba5:	75 0c                	jne    bb3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 baa:	8b 10                	mov    (%eax),%edx
 bac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 baf:	89 10                	mov    %edx,(%eax)
 bb1:	eb 26                	jmp    bd9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb6:	8b 40 04             	mov    0x4(%eax),%eax
 bb9:	2b 45 ec             	sub    -0x14(%ebp),%eax
 bbc:	89 c2                	mov    %eax,%edx
 bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc7:	8b 40 04             	mov    0x4(%eax),%eax
 bca:	c1 e0 03             	shl    $0x3,%eax
 bcd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 bd6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bdc:	a3 68 11 00 00       	mov    %eax,0x1168
      return (void*)(p + 1);
 be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be4:	83 c0 08             	add    $0x8,%eax
 be7:	eb 38                	jmp    c21 <malloc+0xde>
    }
    if(p == freep)
 be9:	a1 68 11 00 00       	mov    0x1168,%eax
 bee:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 bf1:	75 1b                	jne    c0e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 bf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bf6:	89 04 24             	mov    %eax,(%esp)
 bf9:	e8 ed fe ff ff       	call   aeb <morecore>
 bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c05:	75 07                	jne    c0e <malloc+0xcb>
        return 0;
 c07:	b8 00 00 00 00       	mov    $0x0,%eax
 c0c:	eb 13                	jmp    c21 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c11:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c17:	8b 00                	mov    (%eax),%eax
 c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c1c:	e9 70 ff ff ff       	jmp    b91 <malloc+0x4e>
}
 c21:	c9                   	leave  
 c22:	c3                   	ret    

00000c23 <qthread_create>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "thread.h"

void qthread_create(qthread_t *t, void *func, void *arg) {
 c23:	55                   	push   %ebp
 c24:	89 e5                	mov    %esp,%ebp
 c26:	83 ec 28             	sub    $0x28,%esp
  uint *stack = (uint*) malloc(STACKSIZE * sizeof(int));
 c29:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 c30:	e8 0e ff ff ff       	call   b43 <malloc>
 c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  stack += STACKSIZE;
 c38:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  *t = threadop(0, func, arg, stack);
 c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c42:	89 44 24 0c          	mov    %eax,0xc(%esp)
 c46:	8b 45 10             	mov    0x10(%ebp),%eax
 c49:	89 44 24 08          	mov    %eax,0x8(%esp)
 c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
 c50:	89 44 24 04          	mov    %eax,0x4(%esp)
 c54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 c5b:	e8 0f fb ff ff       	call   76f <threadop>
 c60:	8b 55 08             	mov    0x8(%ebp),%edx
 c63:	89 02                	mov    %eax,(%edx)
}
 c65:	c9                   	leave  
 c66:	c3                   	ret    

00000c67 <qthread_mutex_init>:

int qthread_mutex_init(qthread_mutex_t *mutex, qthread_mutexattr_t *attr) {
 c67:	55                   	push   %ebp
 c68:	89 e5                	mov    %esp,%ebp
  mutex->locked = 0;
 c6a:	8b 45 08             	mov    0x8(%ebp),%eax
 c6d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return 0;
 c73:	b8 00 00 00 00       	mov    $0x0,%eax
}
 c78:	5d                   	pop    %ebp
 c79:	c3                   	ret    

00000c7a <qthread_cond_init>:

/* qthread_cond_init/destroy - initialize a condition variable. Again
 * we ignore 'attr'.
 */
int qthread_cond_init(qthread_cond_t *cond, qthread_condattr_t *attr) {
 c7a:	55                   	push   %ebp
 c7b:	89 e5                	mov    %esp,%ebp

  cond->waiting.head = 0;
 c7d:	8b 45 08             	mov    0x8(%ebp),%eax
 c80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cond->waiting.tail = 0;
 c86:	8b 45 08             	mov    0x8(%ebp),%eax
 c89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

  return 0;
 c90:	b8 00 00 00 00       	mov    $0x0,%eax
}
 c95:	5d                   	pop    %ebp
 c96:	c3                   	ret    
