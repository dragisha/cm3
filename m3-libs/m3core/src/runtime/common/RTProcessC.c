typedef void (*ForkHandler)(void);

#include "m3core.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifdef M3_USER_THREADS

typedef struct _fork_handlers_t {
  ForkHandler prepare;
  ForkHandler parent;
  ForkHandler child;
} fork_handlers_t;

typedef struct _vector_t {
  void* p;
  size_t count_allocated;
  size_t count_used;
} vector_t;

#define fork_handlers RTProcess__fork_handlers
static vector_t fork_handlers;

M3_DLL_EXPORT
INTEGER
__cdecl
RTProcess__RegisterForkHandlers(ForkHandler prepare,
                                ForkHandler parent,
                                ForkHandler child)
/* This is a replacement for pthread_atfork.
   pthread_atfork could/should work, but apparently using -pthread
   on some systems causes problems with user threads. That
   doesn't really make sense, but oh well. */
{
  typedef fork_handlers_t T;
  T* p = { 0 };
  size_t count_allocated = { 0 };
  size_t count_used = { 0 };
  int ret = { 0 };

  Scheduler__DisableSwitching();
  count_used = fork_handlers.count_used;
  count_allocated = fork_handlers.count_allocated;
  if ((count_used + 1) >= count_allocated)
  {
    size_t new_allocated = count_allocated ? (count_allocated * 3 / 2) : 16;
    p = (T*)calloc(new_allocated, sizeof(T));
    if (!p)
    {
      ret = ENOMEM;
      goto Exit;
    }
    memcpy(p, fork_handlers.p, count_used * sizeof(T));
    free(fork_handlers.p);
    fork_handlers.count_allocated = new_allocated;
    fork_handlers.p = p;
    p += count_used;
  }
  else
  {
    p = count_used + (T*)fork_handlers.p;
  }
  p->prepare = prepare;
  p->parent = parent;
  p->child = child;
  fork_handlers.count_used = (count_used + 1);  
Exit:
  Scheduler__EnableSwitching();
  return ret;
}

#else /* M3_USER_THREADS */

M3_DLL_EXPORT
INTEGER
__cdecl
RTProcess__RegisterForkHandlers(ForkHandler prepare,
                                ForkHandler parent,
                                ForkHandler child)
{
/* FreeBSD < 6 lacks pthread_atfork. Would be good to use autoconf.
 * VMS lacks pthread_atfork? Would be good to use autoconf.
 * Win32 lacks pthread_atfork and fork. OK.
 *
 * As well, for all Posix systems, we could implement
 * atfork ourselves, as long as we provide a fork()
 * wrapper that code uses.
 */
#if defined(_WIN32) \
        || defined(__vms) \
        || (defined(__FreeBSD__) && (__FreeBSD__ < 6))
    return 0;
#else
    while (1)
    {
      int i = pthread_atfork(prepare, parent, child);
      if (i != EAGAIN)
        return i;
      sleep(0);
    }
#endif
}

#endif /* M3_USER_THREADS */

#ifndef _WIN32

M3_DLL_EXPORT
INTEGER
__cdecl
RTProcess__Fork(void)
{
#ifdef M3_USER_THREADS
  int new_pid = { 0 };
  fork_handlers_t* p = { 0 };
  size_t count_used = { 0 };
  size_t i = { 0 };
  int err = { 0 };

  Scheduler__DisableSwitching();
  p = (fork_handlers_t*)fork_handlers.p;
  count_used = fork_handlers.count_used;
  for (i = 0; i < count_used; ++i)
  {
    ForkHandler handler = p[i].prepare;
    if (handler)
      handler();
  }
  new_pid = fork();
  if (new_pid == -1)
    err = errno;
  for (i = 0; i < count_used; ++i)
  {
    ForkHandler handler = (new_pid ? p[i].parent : p[i].child);
    if (handler)
      handler();
  }
  if (new_pid == -1)
    errno = err;
  Scheduler__EnableSwitching();
  return new_pid;
#elif defined(__sun)
  /* Prior to Solaris 2.10, fork() was fork1() or forkall() depending
   * on which library used. In Solaris 2.10, fork() is always fork1(),
   * and a separate forkall() is available. fork1()'s declaration
   * does have some #ifdef guards around it; hopefully ok.
   */
  return fork1();
#else
  return fork();
#endif
}

#endif /* Win32 */

#ifdef __cplusplus
} /* extern "C" */
#endif
