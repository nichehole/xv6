
_test:     file format elf32-i386


Disassembly of section .text:

00000000 <t2_1>:
struct condvar cv;

qthread_t pid[10];
int count = 0;

void t2_1(int pid) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  printf(1, "thread %d is getting the lock\n", pid);
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	89 44 24 08          	mov    %eax,0x8(%esp)
   d:	c7 44 24 04 20 0b 00 	movl   $0xb20,0x4(%esp)
  14:	00 
  15:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1c:	e8 bc 06 00 00       	call   6dd <printf>
  qthread_mutex_lock(&m);
  21:	c7 44 24 04 70 0f 00 	movl   $0xf70,0x4(%esp)
  28:	00 
  29:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  30:	e8 c0 05 00 00       	call   5f5 <threadop>
  printf(1, "thread %d locks\n", pid);
  35:	8b 45 08             	mov    0x8(%ebp),%eax
  38:	89 44 24 08          	mov    %eax,0x8(%esp)
  3c:	c7 44 24 04 3f 0b 00 	movl   $0xb3f,0x4(%esp)
  43:	00 
  44:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4b:	e8 8d 06 00 00       	call   6dd <printf>
  sleep(500);
  50:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
  57:	e8 89 05 00 00       	call   5e5 <sleep>
  printf(1, "thread %d woke up\n", pid);
  5c:	8b 45 08             	mov    0x8(%ebp),%eax
  5f:	89 44 24 08          	mov    %eax,0x8(%esp)
  63:	c7 44 24 04 50 0b 00 	movl   $0xb50,0x4(%esp)
  6a:	00 
  6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  72:	e8 66 06 00 00       	call   6dd <printf>
  qthread_mutex_unlock(&m);
  77:	c7 44 24 04 70 0f 00 	movl   $0xf70,0x4(%esp)
  7e:	00 
  7f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  86:	e8 6a 05 00 00       	call   5f5 <threadop>
  printf(1, "thread %d unlocked\n", pid);
  8b:	8b 45 08             	mov    0x8(%ebp),%eax
  8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  92:	c7 44 24 04 63 0b 00 	movl   $0xb63,0x4(%esp)
  99:	00 
  9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a1:	e8 37 06 00 00       	call   6dd <printf>
  qthread_exit(0);
  a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ad:	00 
  ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b5:	e8 3b 05 00 00       	call   5f5 <threadop>
  //while (1) sleep(500);
}
  ba:	c9                   	leave  
  bb:	c3                   	ret    

000000bc <t2_2>:

void t2_2()
{
  bc:	55                   	push   %ebp
  bd:	89 e5                	mov    %esp,%ebp
  bf:	83 ec 18             	sub    $0x18,%esp
  qthread_mutex_lock(&m);
  c2:	c7 44 24 04 70 0f 00 	movl   $0xf70,0x4(%esp)
  c9:	00 
  ca:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  d1:	e8 1f 05 00 00       	call   5f5 <threadop>
  printf(1, "thread 2 locks\n");
  d6:	c7 44 24 04 77 0b 00 	movl   $0xb77,0x4(%esp)
  dd:	00 
  de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e5:	e8 f3 05 00 00       	call   6dd <printf>
  printf(1, "thread 2 unlocked\n");
  ea:	c7 44 24 04 87 0b 00 	movl   $0xb87,0x4(%esp)
  f1:	00 
  f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f9:	e8 df 05 00 00       	call   6dd <printf>
  qthread_mutex_unlock(&m);
  fe:	c7 44 24 04 70 0f 00 	movl   $0xf70,0x4(%esp)
 105:	00 
 106:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 10d:	e8 e3 04 00 00       	call   5f5 <threadop>
  qthread_exit(0);
 112:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 119:	00 
 11a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 121:	e8 cf 04 00 00       	call   5f5 <threadop>
  //while (1) sleep(500);
}
 126:	c9                   	leave  
 127:	c3                   	ret    

00000128 <t3>:

void t3()
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	83 ec 18             	sub    $0x18,%esp
  qthread_mutex_lock(&m);
 12e:	c7 44 24 04 70 0f 00 	movl   $0xf70,0x4(%esp)
 135:	00 
 136:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
 13d:	e8 b3 04 00 00       	call   5f5 <threadop>
  printf(1, "Thread3 lock\n");
 142:	c7 44 24 04 9a 0b 00 	movl   $0xb9a,0x4(%esp)
 149:	00 
 14a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 151:	e8 87 05 00 00       	call   6dd <printf>
  count++;
 156:	a1 20 0f 00 00       	mov    0xf20,%eax
 15b:	83 c0 01             	add    $0x1,%eax
 15e:	a3 20 0f 00 00       	mov    %eax,0xf20
  printf(1, "count: %d\n", count);
 163:	a1 20 0f 00 00       	mov    0xf20,%eax
 168:	89 44 24 08          	mov    %eax,0x8(%esp)
 16c:	c7 44 24 04 a8 0b 00 	movl   $0xba8,0x4(%esp)
 173:	00 
 174:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 17b:	e8 5d 05 00 00       	call   6dd <printf>
  if (count < N)
 180:	a1 20 0f 00 00       	mov    0xf20,%eax
 185:	83 f8 04             	cmp    $0x4,%eax
 188:	7f 1c                	jg     1a6 <t3+0x7e>
    qthread_cond_wait(&cv, &m);
 18a:	c7 44 24 08 70 0f 00 	movl   $0xf70,0x8(%esp)
 191:	00 
 192:	c7 44 24 04 68 0f 00 	movl   $0xf68,0x4(%esp)
 199:	00 
 19a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 1a1:	e8 4f 04 00 00       	call   5f5 <threadop>
  if (count == N) qthread_cond_broadcast(&cv);
 1a6:	a1 20 0f 00 00       	mov    0xf20,%eax
 1ab:	83 f8 05             	cmp    $0x5,%eax
 1ae:	75 14                	jne    1c4 <t3+0x9c>
 1b0:	c7 44 24 04 68 0f 00 	movl   $0xf68,0x4(%esp)
 1b7:	00 
 1b8:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
 1bf:	e8 31 04 00 00       	call   5f5 <threadop>
  count--;
 1c4:	a1 20 0f 00 00       	mov    0xf20,%eax
 1c9:	83 e8 01             	sub    $0x1,%eax
 1cc:	a3 20 0f 00 00       	mov    %eax,0xf20
  printf(1, "%d\n", count);
 1d1:	a1 20 0f 00 00       	mov    0xf20,%eax
 1d6:	89 44 24 08          	mov    %eax,0x8(%esp)
 1da:	c7 44 24 04 b3 0b 00 	movl   $0xbb3,0x4(%esp)
 1e1:	00 
 1e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1e9:	e8 ef 04 00 00       	call   6dd <printf>
  qthread_mutex_unlock(&m);
 1ee:	c7 44 24 04 70 0f 00 	movl   $0xf70,0x4(%esp)
 1f5:	00 
 1f6:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 1fd:	e8 f3 03 00 00       	call   5f5 <threadop>
  printf(1, "Thread3 unlocked\n");
 202:	c7 44 24 04 b7 0b 00 	movl   $0xbb7,0x4(%esp)
 209:	00 
 20a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 211:	e8 c7 04 00 00       	call   6dd <printf>
  qthread_exit(0);
 216:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 21d:	00 
 21e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 225:	e8 cb 03 00 00       	call   5f5 <threadop>
}
 22a:	c9                   	leave  
 22b:	c3                   	ret    

0000022c <main>:

int
main(int argc, char *argv[])
{
 22c:	55                   	push   %ebp
 22d:	89 e5                	mov    %esp,%ebp
 22f:	83 e4 f0             	and    $0xfffffff0,%esp
 232:	83 ec 20             	sub    $0x20,%esp
  int i;
  printf(1, "BEGIN\n");
 235:	c7 44 24 04 c9 0b 00 	movl   $0xbc9,0x4(%esp)
 23c:	00 
 23d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 244:	e8 94 04 00 00       	call   6dd <printf>
  //int pid3;
  //uint x = 37;
  for (i = 0; i < N; ++i) {
 249:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 250:	00 
 251:	eb 55                	jmp    2a8 <main+0x7c>
    qthread_create(&pid[i], *t3, (void*)i);
 253:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 257:	8b 54 24 1c          	mov    0x1c(%esp),%edx
 25b:	c1 e2 02             	shl    $0x2,%edx
 25e:	81 c2 40 0f 00 00    	add    $0xf40,%edx
 264:	89 44 24 08          	mov    %eax,0x8(%esp)
 268:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
 26f:	00 
 270:	89 14 24             	mov    %edx,(%esp)
 273:	e8 31 08 00 00       	call   aa9 <qthread_create>
    printf(1, "thread %d pid: %d\n", i, pid[i]);
 278:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 27c:	8b 04 85 40 0f 00 00 	mov    0xf40(,%eax,4),%eax
 283:	89 44 24 0c          	mov    %eax,0xc(%esp)
 287:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 28b:	89 44 24 08          	mov    %eax,0x8(%esp)
 28f:	c7 44 24 04 d0 0b 00 	movl   $0xbd0,0x4(%esp)
 296:	00 
 297:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 29e:	e8 3a 04 00 00       	call   6dd <printf>
{
  int i;
  printf(1, "BEGIN\n");
  //int pid3;
  //uint x = 37;
  for (i = 0; i < N; ++i) {
 2a3:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 2a8:	83 7c 24 1c 04       	cmpl   $0x4,0x1c(%esp)
 2ad:	7e a4                	jle    253 <main+0x27>
    qthread_create(&pid[i], *t3, (void*)i);
    printf(1, "thread %d pid: %d\n", i, pid[i]);
  }

  for (i = 0; i < N; ++i)
 2af:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 2b6:	00 
 2b7:	eb 28                	jmp    2e1 <main+0xb5>
    qthread_join(pid[i], 0);
 2b9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 2bd:	8b 04 85 40 0f 00 00 	mov    0xf40(,%eax,4),%eax
 2c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 2cb:	00 
 2cc:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 2d7:	e8 19 03 00 00       	call   5f5 <threadop>
  for (i = 0; i < N; ++i) {
    qthread_create(&pid[i], *t3, (void*)i);
    printf(1, "thread %d pid: %d\n", i, pid[i]);
  }

  for (i = 0; i < N; ++i)
 2dc:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 2e1:	83 7c 24 1c 04       	cmpl   $0x4,0x1c(%esp)
 2e6:	7e d1                	jle    2b9 <main+0x8d>
    qthread_join(pid[i], 0);
  exit();
 2e8:	e8 68 02 00 00       	call   555 <exit>

000002ed <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
 2f0:	57                   	push   %edi
 2f1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2f2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2f5:	8b 55 10             	mov    0x10(%ebp),%edx
 2f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fb:	89 cb                	mov    %ecx,%ebx
 2fd:	89 df                	mov    %ebx,%edi
 2ff:	89 d1                	mov    %edx,%ecx
 301:	fc                   	cld    
 302:	f3 aa                	rep stos %al,%es:(%edi)
 304:	89 ca                	mov    %ecx,%edx
 306:	89 fb                	mov    %edi,%ebx
 308:	89 5d 08             	mov    %ebx,0x8(%ebp)
 30b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 30e:	5b                   	pop    %ebx
 30f:	5f                   	pop    %edi
 310:	5d                   	pop    %ebp
 311:	c3                   	ret    

00000312 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 312:	55                   	push   %ebp
 313:	89 e5                	mov    %esp,%ebp
 315:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 318:	8b 45 08             	mov    0x8(%ebp),%eax
 31b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 31e:	90                   	nop
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	8d 50 01             	lea    0x1(%eax),%edx
 325:	89 55 08             	mov    %edx,0x8(%ebp)
 328:	8b 55 0c             	mov    0xc(%ebp),%edx
 32b:	8d 4a 01             	lea    0x1(%edx),%ecx
 32e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 331:	0f b6 12             	movzbl (%edx),%edx
 334:	88 10                	mov    %dl,(%eax)
 336:	0f b6 00             	movzbl (%eax),%eax
 339:	84 c0                	test   %al,%al
 33b:	75 e2                	jne    31f <strcpy+0xd>
    ;
  return os;
 33d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 340:	c9                   	leave  
 341:	c3                   	ret    

00000342 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 342:	55                   	push   %ebp
 343:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 345:	eb 08                	jmp    34f <strcmp+0xd>
    p++, q++;
 347:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 34b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
 352:	0f b6 00             	movzbl (%eax),%eax
 355:	84 c0                	test   %al,%al
 357:	74 10                	je     369 <strcmp+0x27>
 359:	8b 45 08             	mov    0x8(%ebp),%eax
 35c:	0f b6 10             	movzbl (%eax),%edx
 35f:	8b 45 0c             	mov    0xc(%ebp),%eax
 362:	0f b6 00             	movzbl (%eax),%eax
 365:	38 c2                	cmp    %al,%dl
 367:	74 de                	je     347 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	0f b6 00             	movzbl (%eax),%eax
 36f:	0f b6 d0             	movzbl %al,%edx
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	0f b6 00             	movzbl (%eax),%eax
 378:	0f b6 c0             	movzbl %al,%eax
 37b:	29 c2                	sub    %eax,%edx
 37d:	89 d0                	mov    %edx,%eax
}
 37f:	5d                   	pop    %ebp
 380:	c3                   	ret    

00000381 <strlen>:

uint
strlen(char *s)
{
 381:	55                   	push   %ebp
 382:	89 e5                	mov    %esp,%ebp
 384:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 387:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 38e:	eb 04                	jmp    394 <strlen+0x13>
 390:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 394:	8b 55 fc             	mov    -0x4(%ebp),%edx
 397:	8b 45 08             	mov    0x8(%ebp),%eax
 39a:	01 d0                	add    %edx,%eax
 39c:	0f b6 00             	movzbl (%eax),%eax
 39f:	84 c0                	test   %al,%al
 3a1:	75 ed                	jne    390 <strlen+0xf>
    ;
  return n;
 3a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3a6:	c9                   	leave  
 3a7:	c3                   	ret    

000003a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 3ae:	8b 45 10             	mov    0x10(%ebp),%eax
 3b1:	89 44 24 08          	mov    %eax,0x8(%esp)
 3b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 3bc:	8b 45 08             	mov    0x8(%ebp),%eax
 3bf:	89 04 24             	mov    %eax,(%esp)
 3c2:	e8 26 ff ff ff       	call   2ed <stosb>
  return dst;
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ca:	c9                   	leave  
 3cb:	c3                   	ret    

000003cc <strchr>:

char*
strchr(const char *s, char c)
{
 3cc:	55                   	push   %ebp
 3cd:	89 e5                	mov    %esp,%ebp
 3cf:	83 ec 04             	sub    $0x4,%esp
 3d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d5:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3d8:	eb 14                	jmp    3ee <strchr+0x22>
    if(*s == c)
 3da:	8b 45 08             	mov    0x8(%ebp),%eax
 3dd:	0f b6 00             	movzbl (%eax),%eax
 3e0:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3e3:	75 05                	jne    3ea <strchr+0x1e>
      return (char*)s;
 3e5:	8b 45 08             	mov    0x8(%ebp),%eax
 3e8:	eb 13                	jmp    3fd <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 3ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	0f b6 00             	movzbl (%eax),%eax
 3f4:	84 c0                	test   %al,%al
 3f6:	75 e2                	jne    3da <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 3f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3fd:	c9                   	leave  
 3fe:	c3                   	ret    

000003ff <gets>:

char*
gets(char *buf, int max)
{
 3ff:	55                   	push   %ebp
 400:	89 e5                	mov    %esp,%ebp
 402:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 40c:	eb 4c                	jmp    45a <gets+0x5b>
    cc = read(0, &c, 1);
 40e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 415:	00 
 416:	8d 45 ef             	lea    -0x11(%ebp),%eax
 419:	89 44 24 04          	mov    %eax,0x4(%esp)
 41d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 424:	e8 44 01 00 00       	call   56d <read>
 429:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 42c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 430:	7f 02                	jg     434 <gets+0x35>
      break;
 432:	eb 31                	jmp    465 <gets+0x66>
    buf[i++] = c;
 434:	8b 45 f4             	mov    -0xc(%ebp),%eax
 437:	8d 50 01             	lea    0x1(%eax),%edx
 43a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 43d:	89 c2                	mov    %eax,%edx
 43f:	8b 45 08             	mov    0x8(%ebp),%eax
 442:	01 c2                	add    %eax,%edx
 444:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 448:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 44a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 44e:	3c 0a                	cmp    $0xa,%al
 450:	74 13                	je     465 <gets+0x66>
 452:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 456:	3c 0d                	cmp    $0xd,%al
 458:	74 0b                	je     465 <gets+0x66>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 45a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 45d:	83 c0 01             	add    $0x1,%eax
 460:	3b 45 0c             	cmp    0xc(%ebp),%eax
 463:	7c a9                	jl     40e <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 465:	8b 55 f4             	mov    -0xc(%ebp),%edx
 468:	8b 45 08             	mov    0x8(%ebp),%eax
 46b:	01 d0                	add    %edx,%eax
 46d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 470:	8b 45 08             	mov    0x8(%ebp),%eax
}
 473:	c9                   	leave  
 474:	c3                   	ret    

00000475 <stat>:

int
stat(char *n, struct stat *st)
{
 475:	55                   	push   %ebp
 476:	89 e5                	mov    %esp,%ebp
 478:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 47b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 482:	00 
 483:	8b 45 08             	mov    0x8(%ebp),%eax
 486:	89 04 24             	mov    %eax,(%esp)
 489:	e8 07 01 00 00       	call   595 <open>
 48e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 491:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 495:	79 07                	jns    49e <stat+0x29>
    return -1;
 497:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 49c:	eb 23                	jmp    4c1 <stat+0x4c>
  r = fstat(fd, st);
 49e:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a8:	89 04 24             	mov    %eax,(%esp)
 4ab:	e8 fd 00 00 00       	call   5ad <fstat>
 4b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4b6:	89 04 24             	mov    %eax,(%esp)
 4b9:	e8 bf 00 00 00       	call   57d <close>
  return r;
 4be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4c1:	c9                   	leave  
 4c2:	c3                   	ret    

000004c3 <atoi>:

int
atoi(const char *s)
{
 4c3:	55                   	push   %ebp
 4c4:	89 e5                	mov    %esp,%ebp
 4c6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 4c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 4d0:	eb 25                	jmp    4f7 <atoi+0x34>
    n = n*10 + *s++ - '0';
 4d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4d5:	89 d0                	mov    %edx,%eax
 4d7:	c1 e0 02             	shl    $0x2,%eax
 4da:	01 d0                	add    %edx,%eax
 4dc:	01 c0                	add    %eax,%eax
 4de:	89 c1                	mov    %eax,%ecx
 4e0:	8b 45 08             	mov    0x8(%ebp),%eax
 4e3:	8d 50 01             	lea    0x1(%eax),%edx
 4e6:	89 55 08             	mov    %edx,0x8(%ebp)
 4e9:	0f b6 00             	movzbl (%eax),%eax
 4ec:	0f be c0             	movsbl %al,%eax
 4ef:	01 c8                	add    %ecx,%eax
 4f1:	83 e8 30             	sub    $0x30,%eax
 4f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 4f7:	8b 45 08             	mov    0x8(%ebp),%eax
 4fa:	0f b6 00             	movzbl (%eax),%eax
 4fd:	3c 2f                	cmp    $0x2f,%al
 4ff:	7e 0a                	jle    50b <atoi+0x48>
 501:	8b 45 08             	mov    0x8(%ebp),%eax
 504:	0f b6 00             	movzbl (%eax),%eax
 507:	3c 39                	cmp    $0x39,%al
 509:	7e c7                	jle    4d2 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 50b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 50e:	c9                   	leave  
 50f:	c3                   	ret    

00000510 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 516:	8b 45 08             	mov    0x8(%ebp),%eax
 519:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 51c:	8b 45 0c             	mov    0xc(%ebp),%eax
 51f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 522:	eb 17                	jmp    53b <memmove+0x2b>
    *dst++ = *src++;
 524:	8b 45 fc             	mov    -0x4(%ebp),%eax
 527:	8d 50 01             	lea    0x1(%eax),%edx
 52a:	89 55 fc             	mov    %edx,-0x4(%ebp)
 52d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 530:	8d 4a 01             	lea    0x1(%edx),%ecx
 533:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 536:	0f b6 12             	movzbl (%edx),%edx
 539:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 53b:	8b 45 10             	mov    0x10(%ebp),%eax
 53e:	8d 50 ff             	lea    -0x1(%eax),%edx
 541:	89 55 10             	mov    %edx,0x10(%ebp)
 544:	85 c0                	test   %eax,%eax
 546:	7f dc                	jg     524 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 548:	8b 45 08             	mov    0x8(%ebp),%eax
}
 54b:	c9                   	leave  
 54c:	c3                   	ret    

0000054d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 54d:	b8 01 00 00 00       	mov    $0x1,%eax
 552:	cd 40                	int    $0x40
 554:	c3                   	ret    

00000555 <exit>:
SYSCALL(exit)
 555:	b8 02 00 00 00       	mov    $0x2,%eax
 55a:	cd 40                	int    $0x40
 55c:	c3                   	ret    

0000055d <wait>:
SYSCALL(wait)
 55d:	b8 03 00 00 00       	mov    $0x3,%eax
 562:	cd 40                	int    $0x40
 564:	c3                   	ret    

00000565 <pipe>:
SYSCALL(pipe)
 565:	b8 04 00 00 00       	mov    $0x4,%eax
 56a:	cd 40                	int    $0x40
 56c:	c3                   	ret    

0000056d <read>:
SYSCALL(read)
 56d:	b8 05 00 00 00       	mov    $0x5,%eax
 572:	cd 40                	int    $0x40
 574:	c3                   	ret    

00000575 <write>:
SYSCALL(write)
 575:	b8 10 00 00 00       	mov    $0x10,%eax
 57a:	cd 40                	int    $0x40
 57c:	c3                   	ret    

0000057d <close>:
SYSCALL(close)
 57d:	b8 15 00 00 00       	mov    $0x15,%eax
 582:	cd 40                	int    $0x40
 584:	c3                   	ret    

00000585 <kill>:
SYSCALL(kill)
 585:	b8 06 00 00 00       	mov    $0x6,%eax
 58a:	cd 40                	int    $0x40
 58c:	c3                   	ret    

0000058d <exec>:
SYSCALL(exec)
 58d:	b8 07 00 00 00       	mov    $0x7,%eax
 592:	cd 40                	int    $0x40
 594:	c3                   	ret    

00000595 <open>:
SYSCALL(open)
 595:	b8 0f 00 00 00       	mov    $0xf,%eax
 59a:	cd 40                	int    $0x40
 59c:	c3                   	ret    

0000059d <mknod>:
SYSCALL(mknod)
 59d:	b8 11 00 00 00       	mov    $0x11,%eax
 5a2:	cd 40                	int    $0x40
 5a4:	c3                   	ret    

000005a5 <unlink>:
SYSCALL(unlink)
 5a5:	b8 12 00 00 00       	mov    $0x12,%eax
 5aa:	cd 40                	int    $0x40
 5ac:	c3                   	ret    

000005ad <fstat>:
SYSCALL(fstat)
 5ad:	b8 08 00 00 00       	mov    $0x8,%eax
 5b2:	cd 40                	int    $0x40
 5b4:	c3                   	ret    

000005b5 <link>:
SYSCALL(link)
 5b5:	b8 13 00 00 00       	mov    $0x13,%eax
 5ba:	cd 40                	int    $0x40
 5bc:	c3                   	ret    

000005bd <mkdir>:
SYSCALL(mkdir)
 5bd:	b8 14 00 00 00       	mov    $0x14,%eax
 5c2:	cd 40                	int    $0x40
 5c4:	c3                   	ret    

000005c5 <chdir>:
SYSCALL(chdir)
 5c5:	b8 09 00 00 00       	mov    $0x9,%eax
 5ca:	cd 40                	int    $0x40
 5cc:	c3                   	ret    

000005cd <dup>:
SYSCALL(dup)
 5cd:	b8 0a 00 00 00       	mov    $0xa,%eax
 5d2:	cd 40                	int    $0x40
 5d4:	c3                   	ret    

000005d5 <getpid>:
SYSCALL(getpid)
 5d5:	b8 0b 00 00 00       	mov    $0xb,%eax
 5da:	cd 40                	int    $0x40
 5dc:	c3                   	ret    

000005dd <sbrk>:
SYSCALL(sbrk)
 5dd:	b8 0c 00 00 00       	mov    $0xc,%eax
 5e2:	cd 40                	int    $0x40
 5e4:	c3                   	ret    

000005e5 <sleep>:
SYSCALL(sleep)
 5e5:	b8 0d 00 00 00       	mov    $0xd,%eax
 5ea:	cd 40                	int    $0x40
 5ec:	c3                   	ret    

000005ed <uptime>:
SYSCALL(uptime)
 5ed:	b8 0e 00 00 00       	mov    $0xe,%eax
 5f2:	cd 40                	int    $0x40
 5f4:	c3                   	ret    

000005f5 <threadop>:
SYSCALL(threadop)
 5f5:	b8 16 00 00 00       	mov    $0x16,%eax
 5fa:	cd 40                	int    $0x40
 5fc:	c3                   	ret    

000005fd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5fd:	55                   	push   %ebp
 5fe:	89 e5                	mov    %esp,%ebp
 600:	83 ec 18             	sub    $0x18,%esp
 603:	8b 45 0c             	mov    0xc(%ebp),%eax
 606:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 609:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 610:	00 
 611:	8d 45 f4             	lea    -0xc(%ebp),%eax
 614:	89 44 24 04          	mov    %eax,0x4(%esp)
 618:	8b 45 08             	mov    0x8(%ebp),%eax
 61b:	89 04 24             	mov    %eax,(%esp)
 61e:	e8 52 ff ff ff       	call   575 <write>
}
 623:	c9                   	leave  
 624:	c3                   	ret    

00000625 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 625:	55                   	push   %ebp
 626:	89 e5                	mov    %esp,%ebp
 628:	56                   	push   %esi
 629:	53                   	push   %ebx
 62a:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 62d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 634:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 638:	74 17                	je     651 <printint+0x2c>
 63a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 63e:	79 11                	jns    651 <printint+0x2c>
    neg = 1;
 640:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 647:	8b 45 0c             	mov    0xc(%ebp),%eax
 64a:	f7 d8                	neg    %eax
 64c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 64f:	eb 06                	jmp    657 <printint+0x32>
  } else {
    x = xx;
 651:	8b 45 0c             	mov    0xc(%ebp),%eax
 654:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 657:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 65e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 661:	8d 41 01             	lea    0x1(%ecx),%eax
 664:	89 45 f4             	mov    %eax,-0xc(%ebp)
 667:	8b 5d 10             	mov    0x10(%ebp),%ebx
 66a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 66d:	ba 00 00 00 00       	mov    $0x0,%edx
 672:	f7 f3                	div    %ebx
 674:	89 d0                	mov    %edx,%eax
 676:	0f b6 80 f0 0e 00 00 	movzbl 0xef0(%eax),%eax
 67d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 681:	8b 75 10             	mov    0x10(%ebp),%esi
 684:	8b 45 ec             	mov    -0x14(%ebp),%eax
 687:	ba 00 00 00 00       	mov    $0x0,%edx
 68c:	f7 f6                	div    %esi
 68e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 691:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 695:	75 c7                	jne    65e <printint+0x39>
  if(neg)
 697:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 69b:	74 10                	je     6ad <printint+0x88>
    buf[i++] = '-';
 69d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a0:	8d 50 01             	lea    0x1(%eax),%edx
 6a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6a6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6ab:	eb 1f                	jmp    6cc <printint+0xa7>
 6ad:	eb 1d                	jmp    6cc <printint+0xa7>
    putc(fd, buf[i]);
 6af:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b5:	01 d0                	add    %edx,%eax
 6b7:	0f b6 00             	movzbl (%eax),%eax
 6ba:	0f be c0             	movsbl %al,%eax
 6bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c1:	8b 45 08             	mov    0x8(%ebp),%eax
 6c4:	89 04 24             	mov    %eax,(%esp)
 6c7:	e8 31 ff ff ff       	call   5fd <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6cc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6d4:	79 d9                	jns    6af <printint+0x8a>
    putc(fd, buf[i]);
}
 6d6:	83 c4 30             	add    $0x30,%esp
 6d9:	5b                   	pop    %ebx
 6da:	5e                   	pop    %esi
 6db:	5d                   	pop    %ebp
 6dc:	c3                   	ret    

000006dd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6dd:	55                   	push   %ebp
 6de:	89 e5                	mov    %esp,%ebp
 6e0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6ea:	8d 45 0c             	lea    0xc(%ebp),%eax
 6ed:	83 c0 04             	add    $0x4,%eax
 6f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6fa:	e9 7c 01 00 00       	jmp    87b <printf+0x19e>
    c = fmt[i] & 0xff;
 6ff:	8b 55 0c             	mov    0xc(%ebp),%edx
 702:	8b 45 f0             	mov    -0x10(%ebp),%eax
 705:	01 d0                	add    %edx,%eax
 707:	0f b6 00             	movzbl (%eax),%eax
 70a:	0f be c0             	movsbl %al,%eax
 70d:	25 ff 00 00 00       	and    $0xff,%eax
 712:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 715:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 719:	75 2c                	jne    747 <printf+0x6a>
      if(c == '%'){
 71b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 71f:	75 0c                	jne    72d <printf+0x50>
        state = '%';
 721:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 728:	e9 4a 01 00 00       	jmp    877 <printf+0x19a>
      } else {
        putc(fd, c);
 72d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 730:	0f be c0             	movsbl %al,%eax
 733:	89 44 24 04          	mov    %eax,0x4(%esp)
 737:	8b 45 08             	mov    0x8(%ebp),%eax
 73a:	89 04 24             	mov    %eax,(%esp)
 73d:	e8 bb fe ff ff       	call   5fd <putc>
 742:	e9 30 01 00 00       	jmp    877 <printf+0x19a>
      }
    } else if(state == '%'){
 747:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 74b:	0f 85 26 01 00 00    	jne    877 <printf+0x19a>
      if(c == 'd'){
 751:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 755:	75 2d                	jne    784 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 757:	8b 45 e8             	mov    -0x18(%ebp),%eax
 75a:	8b 00                	mov    (%eax),%eax
 75c:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 763:	00 
 764:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 76b:	00 
 76c:	89 44 24 04          	mov    %eax,0x4(%esp)
 770:	8b 45 08             	mov    0x8(%ebp),%eax
 773:	89 04 24             	mov    %eax,(%esp)
 776:	e8 aa fe ff ff       	call   625 <printint>
        ap++;
 77b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 77f:	e9 ec 00 00 00       	jmp    870 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 784:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 788:	74 06                	je     790 <printf+0xb3>
 78a:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 78e:	75 2d                	jne    7bd <printf+0xe0>
        printint(fd, *ap, 16, 0);
 790:	8b 45 e8             	mov    -0x18(%ebp),%eax
 793:	8b 00                	mov    (%eax),%eax
 795:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 79c:	00 
 79d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 7a4:	00 
 7a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a9:	8b 45 08             	mov    0x8(%ebp),%eax
 7ac:	89 04 24             	mov    %eax,(%esp)
 7af:	e8 71 fe ff ff       	call   625 <printint>
        ap++;
 7b4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7b8:	e9 b3 00 00 00       	jmp    870 <printf+0x193>
      } else if(c == 's'){
 7bd:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7c1:	75 45                	jne    808 <printf+0x12b>
        s = (char*)*ap;
 7c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7c6:	8b 00                	mov    (%eax),%eax
 7c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d3:	75 09                	jne    7de <printf+0x101>
          s = "(null)";
 7d5:	c7 45 f4 e3 0b 00 00 	movl   $0xbe3,-0xc(%ebp)
        while(*s != 0){
 7dc:	eb 1e                	jmp    7fc <printf+0x11f>
 7de:	eb 1c                	jmp    7fc <printf+0x11f>
          putc(fd, *s);
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	0f b6 00             	movzbl (%eax),%eax
 7e6:	0f be c0             	movsbl %al,%eax
 7e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ed:	8b 45 08             	mov    0x8(%ebp),%eax
 7f0:	89 04 24             	mov    %eax,(%esp)
 7f3:	e8 05 fe ff ff       	call   5fd <putc>
          s++;
 7f8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ff:	0f b6 00             	movzbl (%eax),%eax
 802:	84 c0                	test   %al,%al
 804:	75 da                	jne    7e0 <printf+0x103>
 806:	eb 68                	jmp    870 <printf+0x193>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 808:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 80c:	75 1d                	jne    82b <printf+0x14e>
        putc(fd, *ap);
 80e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 811:	8b 00                	mov    (%eax),%eax
 813:	0f be c0             	movsbl %al,%eax
 816:	89 44 24 04          	mov    %eax,0x4(%esp)
 81a:	8b 45 08             	mov    0x8(%ebp),%eax
 81d:	89 04 24             	mov    %eax,(%esp)
 820:	e8 d8 fd ff ff       	call   5fd <putc>
        ap++;
 825:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 829:	eb 45                	jmp    870 <printf+0x193>
      } else if(c == '%'){
 82b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 82f:	75 17                	jne    848 <printf+0x16b>
        putc(fd, c);
 831:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 834:	0f be c0             	movsbl %al,%eax
 837:	89 44 24 04          	mov    %eax,0x4(%esp)
 83b:	8b 45 08             	mov    0x8(%ebp),%eax
 83e:	89 04 24             	mov    %eax,(%esp)
 841:	e8 b7 fd ff ff       	call   5fd <putc>
 846:	eb 28                	jmp    870 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 848:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 84f:	00 
 850:	8b 45 08             	mov    0x8(%ebp),%eax
 853:	89 04 24             	mov    %eax,(%esp)
 856:	e8 a2 fd ff ff       	call   5fd <putc>
        putc(fd, c);
 85b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 85e:	0f be c0             	movsbl %al,%eax
 861:	89 44 24 04          	mov    %eax,0x4(%esp)
 865:	8b 45 08             	mov    0x8(%ebp),%eax
 868:	89 04 24             	mov    %eax,(%esp)
 86b:	e8 8d fd ff ff       	call   5fd <putc>
      }
      state = 0;
 870:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 877:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 87b:	8b 55 0c             	mov    0xc(%ebp),%edx
 87e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 881:	01 d0                	add    %edx,%eax
 883:	0f b6 00             	movzbl (%eax),%eax
 886:	84 c0                	test   %al,%al
 888:	0f 85 71 fe ff ff    	jne    6ff <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 88e:	c9                   	leave  
 88f:	c3                   	ret    

00000890 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 896:	8b 45 08             	mov    0x8(%ebp),%eax
 899:	83 e8 08             	sub    $0x8,%eax
 89c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89f:	a1 2c 0f 00 00       	mov    0xf2c,%eax
 8a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8a7:	eb 24                	jmp    8cd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ac:	8b 00                	mov    (%eax),%eax
 8ae:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8b1:	77 12                	ja     8c5 <free+0x35>
 8b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8b9:	77 24                	ja     8df <free+0x4f>
 8bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8be:	8b 00                	mov    (%eax),%eax
 8c0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8c3:	77 1a                	ja     8df <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c8:	8b 00                	mov    (%eax),%eax
 8ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8d3:	76 d4                	jbe    8a9 <free+0x19>
 8d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d8:	8b 00                	mov    (%eax),%eax
 8da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8dd:	76 ca                	jbe    8a9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e2:	8b 40 04             	mov    0x4(%eax),%eax
 8e5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ef:	01 c2                	add    %eax,%edx
 8f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f4:	8b 00                	mov    (%eax),%eax
 8f6:	39 c2                	cmp    %eax,%edx
 8f8:	75 24                	jne    91e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fd:	8b 50 04             	mov    0x4(%eax),%edx
 900:	8b 45 fc             	mov    -0x4(%ebp),%eax
 903:	8b 00                	mov    (%eax),%eax
 905:	8b 40 04             	mov    0x4(%eax),%eax
 908:	01 c2                	add    %eax,%edx
 90a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 910:	8b 45 fc             	mov    -0x4(%ebp),%eax
 913:	8b 00                	mov    (%eax),%eax
 915:	8b 10                	mov    (%eax),%edx
 917:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91a:	89 10                	mov    %edx,(%eax)
 91c:	eb 0a                	jmp    928 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 91e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 921:	8b 10                	mov    (%eax),%edx
 923:	8b 45 f8             	mov    -0x8(%ebp),%eax
 926:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 928:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92b:	8b 40 04             	mov    0x4(%eax),%eax
 92e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 935:	8b 45 fc             	mov    -0x4(%ebp),%eax
 938:	01 d0                	add    %edx,%eax
 93a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 93d:	75 20                	jne    95f <free+0xcf>
    p->s.size += bp->s.size;
 93f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 942:	8b 50 04             	mov    0x4(%eax),%edx
 945:	8b 45 f8             	mov    -0x8(%ebp),%eax
 948:	8b 40 04             	mov    0x4(%eax),%eax
 94b:	01 c2                	add    %eax,%edx
 94d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 950:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 953:	8b 45 f8             	mov    -0x8(%ebp),%eax
 956:	8b 10                	mov    (%eax),%edx
 958:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95b:	89 10                	mov    %edx,(%eax)
 95d:	eb 08                	jmp    967 <free+0xd7>
  } else
    p->s.ptr = bp;
 95f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 962:	8b 55 f8             	mov    -0x8(%ebp),%edx
 965:	89 10                	mov    %edx,(%eax)
  freep = p;
 967:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96a:	a3 2c 0f 00 00       	mov    %eax,0xf2c
}
 96f:	c9                   	leave  
 970:	c3                   	ret    

00000971 <morecore>:

static Header*
morecore(uint nu)
{
 971:	55                   	push   %ebp
 972:	89 e5                	mov    %esp,%ebp
 974:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 977:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 97e:	77 07                	ja     987 <morecore+0x16>
    nu = 4096;
 980:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 987:	8b 45 08             	mov    0x8(%ebp),%eax
 98a:	c1 e0 03             	shl    $0x3,%eax
 98d:	89 04 24             	mov    %eax,(%esp)
 990:	e8 48 fc ff ff       	call   5dd <sbrk>
 995:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 998:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 99c:	75 07                	jne    9a5 <morecore+0x34>
    return 0;
 99e:	b8 00 00 00 00       	mov    $0x0,%eax
 9a3:	eb 22                	jmp    9c7 <morecore+0x56>
  hp = (Header*)p;
 9a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ae:	8b 55 08             	mov    0x8(%ebp),%edx
 9b1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b7:	83 c0 08             	add    $0x8,%eax
 9ba:	89 04 24             	mov    %eax,(%esp)
 9bd:	e8 ce fe ff ff       	call   890 <free>
  return freep;
 9c2:	a1 2c 0f 00 00       	mov    0xf2c,%eax
}
 9c7:	c9                   	leave  
 9c8:	c3                   	ret    

000009c9 <malloc>:

void*
malloc(uint nbytes)
{
 9c9:	55                   	push   %ebp
 9ca:	89 e5                	mov    %esp,%ebp
 9cc:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9cf:	8b 45 08             	mov    0x8(%ebp),%eax
 9d2:	83 c0 07             	add    $0x7,%eax
 9d5:	c1 e8 03             	shr    $0x3,%eax
 9d8:	83 c0 01             	add    $0x1,%eax
 9db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9de:	a1 2c 0f 00 00       	mov    0xf2c,%eax
 9e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9ea:	75 23                	jne    a0f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9ec:	c7 45 f0 24 0f 00 00 	movl   $0xf24,-0x10(%ebp)
 9f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f6:	a3 2c 0f 00 00       	mov    %eax,0xf2c
 9fb:	a1 2c 0f 00 00       	mov    0xf2c,%eax
 a00:	a3 24 0f 00 00       	mov    %eax,0xf24
    base.s.size = 0;
 a05:	c7 05 28 0f 00 00 00 	movl   $0x0,0xf28
 a0c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a12:	8b 00                	mov    (%eax),%eax
 a14:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1a:	8b 40 04             	mov    0x4(%eax),%eax
 a1d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a20:	72 4d                	jb     a6f <malloc+0xa6>
      if(p->s.size == nunits)
 a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a25:	8b 40 04             	mov    0x4(%eax),%eax
 a28:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a2b:	75 0c                	jne    a39 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a30:	8b 10                	mov    (%eax),%edx
 a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a35:	89 10                	mov    %edx,(%eax)
 a37:	eb 26                	jmp    a5f <malloc+0x96>
      else {
        p->s.size -= nunits;
 a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3c:	8b 40 04             	mov    0x4(%eax),%eax
 a3f:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a42:	89 c2                	mov    %eax,%edx
 a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a47:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4d:	8b 40 04             	mov    0x4(%eax),%eax
 a50:	c1 e0 03             	shl    $0x3,%eax
 a53:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a59:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a5c:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a62:	a3 2c 0f 00 00       	mov    %eax,0xf2c
      return (void*)(p + 1);
 a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6a:	83 c0 08             	add    $0x8,%eax
 a6d:	eb 38                	jmp    aa7 <malloc+0xde>
    }
    if(p == freep)
 a6f:	a1 2c 0f 00 00       	mov    0xf2c,%eax
 a74:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a77:	75 1b                	jne    a94 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a79:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a7c:	89 04 24             	mov    %eax,(%esp)
 a7f:	e8 ed fe ff ff       	call   971 <morecore>
 a84:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a8b:	75 07                	jne    a94 <malloc+0xcb>
        return 0;
 a8d:	b8 00 00 00 00       	mov    $0x0,%eax
 a92:	eb 13                	jmp    aa7 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9d:	8b 00                	mov    (%eax),%eax
 a9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 aa2:	e9 70 ff ff ff       	jmp    a17 <malloc+0x4e>
}
 aa7:	c9                   	leave  
 aa8:	c3                   	ret    

00000aa9 <qthread_create>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "thread.h"

void qthread_create(qthread_t *t, void *func, void *arg) {
 aa9:	55                   	push   %ebp
 aaa:	89 e5                	mov    %esp,%ebp
 aac:	83 ec 28             	sub    $0x28,%esp
  uint *stack = (uint*) malloc(STACKSIZE * sizeof(int));
 aaf:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
 ab6:	e8 0e ff ff ff       	call   9c9 <malloc>
 abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  stack += STACKSIZE;
 abe:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  *t = threadop(0, func, arg, stack);
 ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac8:	89 44 24 0c          	mov    %eax,0xc(%esp)
 acc:	8b 45 10             	mov    0x10(%ebp),%eax
 acf:	89 44 24 08          	mov    %eax,0x8(%esp)
 ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
 ad6:	89 44 24 04          	mov    %eax,0x4(%esp)
 ada:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 ae1:	e8 0f fb ff ff       	call   5f5 <threadop>
 ae6:	8b 55 08             	mov    0x8(%ebp),%edx
 ae9:	89 02                	mov    %eax,(%edx)
}
 aeb:	c9                   	leave  
 aec:	c3                   	ret    

00000aed <qthread_mutex_init>:

int qthread_mutex_init(qthread_mutex_t *mutex, qthread_mutexattr_t *attr) {
 aed:	55                   	push   %ebp
 aee:	89 e5                	mov    %esp,%ebp
  mutex->locked = 0;
 af0:	8b 45 08             	mov    0x8(%ebp),%eax
 af3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return 0;
 af9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 afe:	5d                   	pop    %ebp
 aff:	c3                   	ret    

00000b00 <qthread_cond_init>:

/* qthread_cond_init/destroy - initialize a condition variable. Again
 * we ignore 'attr'.
 */
int qthread_cond_init(qthread_cond_t *cond, qthread_condattr_t *attr) {
 b00:	55                   	push   %ebp
 b01:	89 e5                	mov    %esp,%ebp

  cond->waiting.head = 0;
 b03:	8b 45 08             	mov    0x8(%ebp),%eax
 b06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  cond->waiting.tail = 0;
 b0c:	8b 45 08             	mov    0x8(%ebp),%eax
 b0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

  return 0;
 b16:	b8 00 00 00 00       	mov    $0x0,%eax
}
 b1b:	5d                   	pop    %ebp
 b1c:	c3                   	ret    
