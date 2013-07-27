/* ----------------------------------------------------------------------------
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.4
 * 
 * This file is not intended to be easily readable and contains a number of 
 * coding conventions designed to improve portability and efficiency. Do not make
 * changes to this file unless you know what you are doing--modify the SWIG 
 * interface file instead. 
 * ----------------------------------------------------------------------------- */

#define SWIGMODULA3


#ifdef __cplusplus
/* SwigValueWrapper is described in swig.swg */
template<typename T> class SwigValueWrapper {
  struct SwigMovePointer {
    T *ptr;
    SwigMovePointer(T *p) : ptr(p) { }
    ~SwigMovePointer() { delete ptr; }
    SwigMovePointer& operator=(SwigMovePointer& rhs) { T* oldptr = ptr; ptr = 0; delete oldptr; ptr = rhs.ptr; rhs.ptr = 0; return *this; }
  } pointer;
  SwigValueWrapper& operator=(const SwigValueWrapper<T>& rhs);
  SwigValueWrapper(const SwigValueWrapper<T>& rhs);
public:
  SwigValueWrapper() : pointer(0) { }
  SwigValueWrapper& operator=(const T& t) { SwigMovePointer tmp(new T(t)); pointer = tmp; return *this; }
  operator T&() const { return *pointer.ptr; }
  T *operator&() { return pointer.ptr; }
};

template <typename T> T SwigValueInit() {
  return T();
}
#endif

/* -----------------------------------------------------------------------------
 *  This section contains generic SWIG labels for method/variable
 *  declarations/attributes, and other compiler dependent labels.
 * ----------------------------------------------------------------------------- */

/* template workaround for compilers that cannot correctly implement the C++ standard */
#ifndef SWIGTEMPLATEDISAMBIGUATOR
# if defined(__SUNPRO_CC) && (__SUNPRO_CC <= 0x560)
#  define SWIGTEMPLATEDISAMBIGUATOR template
# elif defined(__HP_aCC)
/* Needed even with `aCC -AA' when `aCC -V' reports HP ANSI C++ B3910B A.03.55 */
/* If we find a maximum version that requires this, the test would be __HP_aCC <= 35500 for A.03.55 */
#  define SWIGTEMPLATEDISAMBIGUATOR template
# else
#  define SWIGTEMPLATEDISAMBIGUATOR
# endif
#endif

/* inline attribute */
#ifndef SWIGINLINE
# if defined(__cplusplus) || (defined(__GNUC__) && !defined(__STRICT_ANSI__))
#   define SWIGINLINE inline
# else
#   define SWIGINLINE
# endif
#endif

/* attribute recognised by some compilers to avoid 'unused' warnings */
#ifndef SWIGUNUSED
# if defined(__GNUC__)
#   if !(defined(__cplusplus)) || (__GNUC__ > 3 || (__GNUC__ == 3 && __GNUC_MINOR__ >= 4))
#     define SWIGUNUSED __attribute__ ((__unused__)) 
#   else
#     define SWIGUNUSED
#   endif
# elif defined(__ICC)
#   define SWIGUNUSED __attribute__ ((__unused__)) 
# else
#   define SWIGUNUSED 
# endif
#endif

#ifndef SWIG_MSC_UNSUPPRESS_4505
# if defined(_MSC_VER)
#   pragma warning(disable : 4505) /* unreferenced local function has been removed */
# endif 
#endif

#ifndef SWIGUNUSEDPARM
# ifdef __cplusplus
#   define SWIGUNUSEDPARM(p)
# else
#   define SWIGUNUSEDPARM(p) p SWIGUNUSED 
# endif
#endif

/* internal SWIG method */
#ifndef SWIGINTERN
# define SWIGINTERN static SWIGUNUSED
#endif

/* internal inline SWIG method */
#ifndef SWIGINTERNINLINE
# define SWIGINTERNINLINE SWIGINTERN SWIGINLINE
#endif

/* exporting methods */
#if (__GNUC__ >= 4) || (__GNUC__ == 3 && __GNUC_MINOR__ >= 4)
#  ifndef GCC_HASCLASSVISIBILITY
#    define GCC_HASCLASSVISIBILITY
#  endif
#endif

#ifndef SWIGEXPORT
# if defined(_WIN32) || defined(__WIN32__) || defined(__CYGWIN__)
#   if defined(STATIC_LINKED)
#     define SWIGEXPORT
#   else
#     define SWIGEXPORT __declspec(dllexport)
#   endif
# else
#   if defined(__GNUC__) && defined(GCC_HASCLASSVISIBILITY)
#     define SWIGEXPORT __attribute__ ((visibility("default")))
#   else
#     define SWIGEXPORT
#   endif
# endif
#endif

/* calling conventions for Windows */
#ifndef SWIGSTDCALL
# if defined(_WIN32) || defined(__WIN32__) || defined(__CYGWIN__)
#   define SWIGSTDCALL __stdcall
# else
#   define SWIGSTDCALL
# endif 
#endif

/* Deal with Microsoft's attempt at deprecating C standard runtime functions */
#if !defined(SWIG_NO_CRT_SECURE_NO_DEPRECATE) && defined(_MSC_VER) && !defined(_CRT_SECURE_NO_DEPRECATE)
# define _CRT_SECURE_NO_DEPRECATE
#endif

/* Deal with Microsoft's attempt at deprecating methods in the standard C++ library */
#if !defined(SWIG_NO_SCL_SECURE_NO_DEPRECATE) && defined(_MSC_VER) && !defined(_SCL_SECURE_NO_DEPRECATE)
# define _SCL_SECURE_NO_DEPRECATE
#endif




#include <stdlib.h>
#include <string.h>
#include <stdio.h>


#include "dynamicqobject.h"


#ifdef __cplusplus
extern "C" {
#endif

SWIGEXPORT void Delete_AbstractDynamicSlot(AbstractDynamicSlot * self) {
  AbstractDynamicSlot *arg1 = (AbstractDynamicSlot *) 0 ;
  
  arg1 = *(AbstractDynamicSlot **)&self; 
  delete arg1;
}


SWIGEXPORT int AbstractDynamicQObject_qt_metacall(AbstractDynamicQObject * self, QMetaObject::Call c, int id, void ** arguments) {
  AbstractDynamicQObject *arg1 = (AbstractDynamicQObject *) 0 ;
  QMetaObject::Call arg2 ;
  int arg3 ;
  void **arg4 = (void **) 0 ;
  QMetaObject::Call *argp2 ;
  int result;
  int cresult ;
  
  arg1 = *(AbstractDynamicQObject **)&self; 
  argp2 = *(QMetaObject::Call **)&c;
  /*
     if (!argp2) {
  //     SWIG_JavaThrowException(jenv, SWIG_JavaNullPointerException, "Attempt to dereference null QMetaObject::Call");
       //RETURN 0;
       return 0;
     }
  */
  arg2 = *argp2; 
  arg3 = (int)id; 
  arg4 = *(void ***)&arguments; 
  result = (int)(arg1)->qt_metacall(arg2,arg3,arg4);
  cresult = result; 
  return cresult;
}


SWIGEXPORT bool AbstractDynamicQObject_emitDynamicSignal(AbstractDynamicQObject * self, char * signal, void ** arguments) {
  AbstractDynamicQObject *arg1 = (AbstractDynamicQObject *) 0 ;
  char *arg2 = (char *) 0 ;
  void **arg3 = (void **) 0 ;
  bool result;
  bool cresult ;
  
  arg1 = *(AbstractDynamicQObject **)&self; 
  {
    arg2 = signal;
  }
  arg3 = *(void ***)&arguments; 
  result = (bool)(arg1)->emitDynamicSignal(arg2,arg3);
  cresult = result; 
  return cresult;
}


SWIGEXPORT bool AbstractDynamicQObject_connectDynamicSlot(AbstractDynamicQObject * self, QObject * obj, char * signal, char * slot) {
  AbstractDynamicQObject *arg1 = (AbstractDynamicQObject *) 0 ;
  QObject *arg2 = (QObject *) 0 ;
  char *arg3 = (char *) 0 ;
  char *arg4 = (char *) 0 ;
  bool result;
  bool cresult ;
  
  arg1 = *(AbstractDynamicQObject **)&self; 
  arg2 = *(QObject **)&obj; 
  {
    arg3 = signal;
  }
  {
    arg4 = slot;
  }
  result = (bool)(arg1)->connectDynamicSlot(arg2,arg3,arg4);
  cresult = result; 
  return cresult;
}


SWIGEXPORT bool AbstractDynamicQObject_connectDynamicSignal(AbstractDynamicQObject * self, char * signal, QObject * obj, char * slot) {
  AbstractDynamicQObject *arg1 = (AbstractDynamicQObject *) 0 ;
  char *arg2 = (char *) 0 ;
  QObject *arg3 = (QObject *) 0 ;
  char *arg4 = (char *) 0 ;
  bool result;
  bool cresult ;
  
  arg1 = *(AbstractDynamicQObject **)&self; 
  {
    arg2 = signal;
  }
  arg3 = *(QObject **)&obj; 
  {
    arg4 = slot;
  }
  result = (bool)(arg1)->connectDynamicSignal(arg2,arg3,arg4);
  cresult = result; 
  return cresult;
}


SWIGEXPORT void Delete_AbstractDynamicQObject(AbstractDynamicQObject * self) {
  AbstractDynamicQObject *arg1 = (AbstractDynamicQObject *) 0 ;
  
  arg1 = *(AbstractDynamicQObject **)&self; 
  delete arg1;
}


SWIGEXPORT DynamicQObject * New_DynamicQObject0(callbackfn fn, void * obj) {
  callbackfn arg1 = (callbackfn) 0 ;
  void *arg2 = (void *) 0 ;
  DynamicQObject *result = 0 ;
  DynamicQObject * cresult ;
  
  arg1 = *(callbackfn *)&fn; 
  arg2 = *(void **)&obj; 
  result = (DynamicQObject *)new DynamicQObject(arg1,arg2);
  *(DynamicQObject **)&cresult = result; 
  return cresult;
}


SWIGEXPORT AbstractDynamicSlot * DynamicQObject_createSlot(DynamicQObject * self, char * slot) {
  DynamicQObject *arg1 = (DynamicQObject *) 0 ;
  char *arg2 = (char *) 0 ;
  AbstractDynamicSlot *result = 0 ;
  AbstractDynamicSlot * cresult ;
  
  arg1 = *(DynamicQObject **)&self; 
  {
    arg2 = slot;
  }
  result = (AbstractDynamicSlot *)(arg1)->createSlot(arg2);
  *(AbstractDynamicSlot **)&cresult = result; 
  return cresult;
}


SWIGEXPORT void Delete_DynamicQObject(DynamicQObject * self) {
  DynamicQObject *arg1 = (DynamicQObject *) 0 ;
  
  arg1 = *(DynamicQObject **)&self; 
  delete arg1;
}


SWIGEXPORT Slot * New_Slot0(DynamicQObject * parent, callbackfn fn, void * obj) {
  DynamicQObject *arg1 = (DynamicQObject *) 0 ;
  callbackfn arg2 = (callbackfn) 0 ;
  void *arg3 = (void *) 0 ;
  Slot *result = 0 ;
  Slot * cresult ;
  
  arg1 = *(DynamicQObject **)&parent; 
  arg2 = *(callbackfn *)&fn; 
  arg3 = *(void **)&obj; 
  result = (Slot *)new Slot(arg1,arg2,arg3);
  *(Slot **)&cresult = result; 
  return cresult;
}


SWIGEXPORT void Slot_call(Slot * self, QObject * sender, void ** arguments) {
  Slot *arg1 = (Slot *) 0 ;
  QObject *arg2 = (QObject *) 0 ;
  void **arg3 = (void **) 0 ;
  
  arg1 = *(Slot **)&self; 
  arg2 = *(QObject **)&sender; 
  arg3 = *(void ***)&arguments; 
  (arg1)->call(arg2,arg3);
}


SWIGEXPORT void Delete_Slot(Slot * self) {
  Slot *arg1 = (Slot *) 0 ;
  
  arg1 = *(Slot **)&self; 
  delete arg1;
}


SWIGEXPORT long Modula3_AbstractDynamicQObjectToQObject(long objectRef) {
    long baseptr = 0;
    *(QObject **)&baseptr = *(AbstractDynamicQObject **)&objectRef;
    return baseptr;
}

SWIGEXPORT long Modula3_DynamicQObjectToAbstractDynamicQObject(long objectRef) {
    long baseptr = 0;
    *(AbstractDynamicQObject **)&baseptr = *(DynamicQObject **)&objectRef;
    return baseptr;
}

SWIGEXPORT long Modula3_SlotToAbstractDynamicSlot(long objectRef) {
    long baseptr = 0;
    *(AbstractDynamicSlot **)&baseptr = *(Slot **)&objectRef;
    return baseptr;
}

#ifdef __cplusplus
}
#endif

