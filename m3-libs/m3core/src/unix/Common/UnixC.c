/* Copyright (C) 1993, Digital Equipment Corporation                  */
/* All rights reserved.                                               */
/* See the file COPYRIGHT for a full description.                     */

/*
On some platforms, such as 32bit Linux and 32bit Solaris,
various functions are defined to have 32bit limits by default.
unless #define _FILE_OFFSET_BITS 64, which only affects C source.

Usually they are also available with the name ending in "64" as well.
    open => open64
    stat => stat64
    etc.

It might take a #define to expose those names to C.
(Just to help motivate why there are so many #defines.)

Therefore, saying, e.g.
<*EXTERNAL*> PROCEDURE ftruncate (fd: int; length: off_t): int;

is wrong, unless you constrain off_t to 32 bits, which is not good.

It would be correct to say:
<*EXTERNAL ftruncate64*> PROCEDURE ftruncate (fd: int; length: off_t): int;

However that is not portable.
So use these wrappers instead.
*/

#include "m3unix.h"
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#ifdef _WIN32
#include <windows.h>
#endif

#ifdef __cplusplus
extern "C"
{
#endif

void Unix__Assertions(void)
{
    /* make sure all the Modula-3 types are large enough */

#define CHECK_M3_TYPE_SIZE(x) assert(sizeof(m3_##x) >= sizeof(x))
#define IS_TYPE_SIGNED(x)  (((x)-1) < (x)0)

#ifndef _WIN32

    CHECK_M3_TYPE_SIZE(dev_t);
    CHECK_M3_TYPE_SIZE(gid_t);
    CHECK_M3_TYPE_SIZE(ino_t);
    CHECK_M3_TYPE_SIZE(mode_t);
    CHECK_M3_TYPE_SIZE(nlink_t);
    CHECK_M3_TYPE_SIZE(off_t);
    CHECK_M3_TYPE_SIZE(pid_t);
    CHECK_M3_TYPE_SIZE(pthread_t);
    CHECK_M3_TYPE_SIZE(uid_t);

    assert(IS_TYPE_SIGNED(pid_t) == 1);

#endif

    assert(CHAR_BIT == 8);
    assert(sizeof(short) == 2);
    assert(sizeof(int) == 4);
    assert((sizeof(long) == 4) || (sizeof(long) == 8));
    assert((sizeof(void*) == 4) || (sizeof(void*) == 8));
    assert((sizeof(size_t) == 4) || (sizeof(size_t) == 8));
    assert(sizeof(void*) == sizeof(size_t));
#ifndef _WIN64
    assert(sizeof(void*) == sizeof(long));
    assert(sizeof(size_t) == sizeof(long));
#endif
#ifdef _MSC_VER
    assert(sizeof(__int64) == 8);
#else
    assert(sizeof(long long) == 8);
#endif
}

/* open doesn't take any off_t parameter, but there is open64, that
#define _FILE_OFFSET_BITS 64 maps open to. */
int Unix__open(const char* path, int flags, m3_mode_t mode)
{
    return open(path, flags, mode);
}

/* wrapped in case passing mode_t vs. int varies */
int Unix__mkdir(const char* path, m3_mode_t mode)
{
#ifdef _WIN32
    return _mkdir(path);
#else
    return mkdir(path, mode);
#endif
}

#ifndef _WIN32

int Unix__truncate(const char* file, m3_off_t length)
{
    return truncate(file, length);
}

int Unix__ftruncate(int file, m3_off_t length)
{
    return ftruncate(file, length);
}

#endif

m3_off_t Unix__lseek(int fd, m3_off_t offset, int whence)
{
#ifdef _WIN32
    return _lseeki64(fd, offset, whence);
#else
    return lseek(fd, offset, whence);
#endif
}

#ifndef _WIN32

int Unix__fcntl(int fd, int request, int arg)
/* fcntl is actually fcntl(fd, request, ...).
Wrapper is needed on some systems to handle varargs.
See http://edoofus.blogspot.com/2008/08/interesting-bug-unbreaking-cvsupamd64.html.
*/
{
#ifdef __sun
/*
 * This is to work around a bug in the Solaris-2 'libsocket' library 
 * which redefines 'fcntl' in such a way as to zero out 'errno' if the
 * call is successful.
 * See m3-libs/m3core/src/unix/solaris-2-x/Unix.m3.
 */
    int e = errno;
    int r = fcntl(fd, request, arg);
    if (r == 0)
        errno = e;
    return r;
#else
    return fcntl(fd, request, arg);
#endif
}

int Unix__ioctl(int fd, int request, void* argp)
/* ioctl is varargs. See fcntl. */
{
#ifdef __sun
/*
 * This is to work around a bug in the Solaris-2 'libsocket' library 
 * which redefines 'ioctl' in such a way as to zero out 'errno' if the
 * call is successful.
 * See m3-libs/m3core/src/unix/solaris-2-x/Unix.m3.
 */
    int e = errno;
    int r = ioctl(fd, request, argp);
    if (r == 0)
        errno = e;
    return r;
#else
    return ioctl(fd, request, argp);
#endif
}

int Unix__mknod(const char* path, m3_mode_t mode, m3_dev_t dev)
/* no good reason to wrap this */
{
    return mknod(path, mode, dev);
}

#endif

m3_mode_t Unix__umask(m3_mode_t newmask)
{
    return umask(newmask);
}

int Unix__link(const char* ExistingFile, const char* NewLink)
{
#ifdef _WIN32
    typedef BOOL (__stdcall * PFNCreateHardLinkA)(PCSTR NewLink, PCSTR ExistingFile, void* reserved);
    static PFNCreateHardLinkA pfnCreateHardLinkA;
    
    if (pfnCreateHardLinkA == NULL)
    {
        const static WCHAR Kernel32Name[] = L"Kernel32.dll";
        HMODULE Kernel32Handle = LoadLibraryW(Kernel32Name);
        if (Kernel32Handle == NULL)
            goto Error;
        pfnCreateHardLinkA = (PFNCreateHardLinkA)GetProcAddress(Kernel32Handle, "CreateHardLinkA");
        if (pfnCreateHardLinkA == NULL)
            goto Error;
    }
    if (pfnCreateHardLinkA(NewLink, ExistingFile, NULL) == FALSE)
        goto Error;
    return 0;
Error:
    errno = GetLastError();
    return -1;
#else
    return link(ExistingFile, NewLink);
#endif
}

int Unix__chmod(const char* path, m3_mode_t mode)
{
    return chmod(path, mode);
}

#ifndef _WIN32

int Unix__fchmod(int fd, m3_mode_t mode)
{
    return fchmod(fd, mode);
}

int Unix__chown(const char* path, m3_uid_t owner, m3_gid_t group)
{
    return chown(path, owner, group);
}

int Unix__fchown(int fd, m3_uid_t owner, m3_gid_t group)
{
    return fchown(fd, owner, group);
}

#endif

int Unix__creat(const char* path, m3_mode_t mode)
{
    return creat(path, mode);
}

int Unix__dup(int oldd)
{
    return dup(oldd);
}

#ifndef _WIN32

m3_pid_t Unix__fork(void) { return fork(); }

#endif

int Unix__system(const char* s) { return system(s); }

int Unix__isatty(int file) { return isatty(file); }

#ifndef _WIN32

INTEGER Unix__readlink(const char* path, void* buf, INTEGER bufsize) { return readlink(path, buf, bufsize); }

int Unix__symlink(const char* name1, const char* name2) { return symlink(name1, name2); }

int Unix__utimes(const char* file, const timeval_t* tvp) { return utimes(file, tvp); }

int Unix__pipe(int files[2]) { return pipe(files); }

#endif

int Unix__rename(const char* from, const char* to) { return rename(from, to); }

int Unix__rmdir(const char* path) { return rmdir(path); }

int Unix__unlink(const char* path) { return unlink(path); }

int Unix__select(int nfds, fd_set* readfds, fd_set* writefds, fd_set* exceptfds, timeval_t* timeout)
{
    return select(nfds, readfds, writefds, exceptfds, timeout);
}

#ifdef __cplusplus
} /* extern C */
#endif
