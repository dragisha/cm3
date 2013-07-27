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


#include <QtCore/qobject.h>


#ifdef __cplusplus
extern "C" {
#endif

SWIGEXPORT QObject * New_QObject0(QObject * parent) {
  QObject *arg1 = (QObject *) 0 ;
  QObject *result = 0 ;
  QObject * cresult ;
  
  arg1 = *(QObject **)&parent; 
  result = (QObject *)new QObject(arg1);
  *(QObject **)&cresult = result; 
  return cresult;
}


SWIGEXPORT QObject * New_QObject1() {
  QObject *result = 0 ;
  QObject * cresult ;
  
  result = (QObject *)new QObject();
  *(QObject **)&cresult = result; 
  return cresult;
}


SWIGEXPORT void Delete_QObject(QObject * self) {
  QObject *arg1 = (QObject *) 0 ;
  
  arg1 = *(QObject **)&self; 
  delete arg1;
}


SWIGEXPORT bool QObject_event(QObject * self, QEvent * m3arg2) {
  QObject *arg1 = (QObject *) 0 ;
  QEvent *arg2 = (QEvent *) 0 ;
  bool result;
  bool cresult ;
  
  arg1 = *(QObject **)&self; 
  arg2 = *(QEvent **)&m3arg2; 
  result = (bool)(arg1)->event(arg2);
  cresult = result; 
  return cresult;
}


SWIGEXPORT bool QObject_eventFilter(QObject * self, QObject * m3arg2, QEvent * m3arg3) {
  QObject *arg1 = (QObject *) 0 ;
  QObject *arg2 = (QObject *) 0 ;
  QEvent *arg3 = (QEvent *) 0 ;
  bool result;
  bool cresult ;
  
  arg1 = *(QObject **)&self; 
  arg2 = *(QObject **)&m3arg2; 
  arg3 = *(QEvent **)&m3arg3; 
  result = (bool)(arg1)->eventFilter(arg2,arg3);
  cresult = result; 
  return cresult;
}


SWIGEXPORT QString * QObject_objectName(QObject const * self) {
  QObject *arg1 = (QObject *) 0 ;
  QString * cresult ;
  
  arg1 = *(QObject **)&self; 
  *(QString **)&cresult = new QString((const QString &)((QObject const *)arg1)->objectName());
  return cresult;
}


SWIGEXPORT void QObject_setObjectName(QObject * self, QString * name) {
  QObject *arg1 = (QObject *) 0 ;
  QString *arg2 = 0 ;
  
  arg1 = *(QObject **)&self; 
  arg2 = *(QString **)&name;
  (arg1)->setObjectName((QString const &)*arg2);
}


SWIGEXPORT bool QObject_isWidgetType(QObject const * self) {
  QObject *arg1 = (QObject *) 0 ;
  bool result;
  bool cresult ;
  
  arg1 = *(QObject **)&self; 
  result = (bool)((QObject const *)arg1)->isWidgetType();
  cresult = result; 
  return cresult;
}


SWIGEXPORT bool QObject_signalsBlocked(QObject const * self) {
  QObject *arg1 = (QObject *) 0 ;
  bool result;
  bool cresult ;
  
  arg1 = *(QObject **)&self; 
  result = (bool)((QObject const *)arg1)->signalsBlocked();
  cresult = result; 
  return cresult;
}


SWIGEXPORT bool QObject_blockSignals(QObject * self, bool b) {
  QObject *arg1 = (QObject *) 0 ;
  bool arg2 ;
  bool result;
  bool cresult ;
  
  arg1 = *(QObject **)&self; 
  arg2 = b ? true : false; 
  result = (bool)(arg1)->blockSignals(arg2);
  cresult = result; 
  return cresult;
}


SWIGEXPORT int QObject_startTimer(QObject * self, int interval) {
  QObject *arg1 = (QObject *) 0 ;
  int arg2 ;
  int result;
  int cresult ;
  
  arg1 = *(QObject **)&self; 
  arg2 = (int)interval; 
  result = (int)(arg1)->startTimer(arg2);
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QObject_killTimer(QObject * self, int id) {
  QObject *arg1 = (QObject *) 0 ;
  int arg2 ;
  
  arg1 = *(QObject **)&self; 
  arg2 = (int)id; 
  (arg1)->killTimer(arg2);
}


SWIGEXPORT void QObject_setParent(QObject * self, QObject * m3arg2) {
  QObject *arg1 = (QObject *) 0 ;
  QObject *arg2 = (QObject *) 0 ;
  
  arg1 = *(QObject **)&self; 
  arg2 = *(QObject **)&m3arg2; 
  (arg1)->setParent(arg2);
}


SWIGEXPORT void QObject_installEventFilter(QObject * self, QObject * m3arg2) {
  QObject *arg1 = (QObject *) 0 ;
  QObject *arg2 = (QObject *) 0 ;
  
  arg1 = *(QObject **)&self; 
  arg2 = *(QObject **)&m3arg2; 
  (arg1)->installEventFilter(arg2);
}


SWIGEXPORT void QObject_removeEventFilter(QObject * self, QObject * m3arg2) {
  QObject *arg1 = (QObject *) 0 ;
  QObject *arg2 = (QObject *) 0 ;
  
  arg1 = *(QObject **)&self; 
  arg2 = *(QObject **)&m3arg2; 
  (arg1)->removeEventFilter(arg2);
}


SWIGEXPORT void QObject_dumpObjectTree(QObject * self) {
  QObject *arg1 = (QObject *) 0 ;
  
  arg1 = *(QObject **)&self; 
  (arg1)->dumpObjectTree();
}


SWIGEXPORT void QObject_dumpObjectInfo(QObject * self) {
  QObject *arg1 = (QObject *) 0 ;
  
  arg1 = *(QObject **)&self; 
  (arg1)->dumpObjectInfo();
}


SWIGEXPORT unsigned int RegisterUserData() {
  unsigned int result;
  unsigned int cresult ;
  
  result = (unsigned int)QObject::registerUserData();
  cresult = result; 
  return cresult;
}


SWIGEXPORT QObject * QObject_parent(QObject const * self) {
  QObject *arg1 = (QObject *) 0 ;
  QObject *result = 0 ;
  QObject * cresult ;
  
  arg1 = *(QObject **)&self; 
  result = (QObject *)((QObject const *)arg1)->parent();
  *(QObject **)&cresult = result; 
  return cresult;
}


SWIGEXPORT bool QObject_inherits(QObject const * self, char * classname) {
  QObject *arg1 = (QObject *) 0 ;
  char *arg2 = (char *) 0 ;
  bool result;
  bool cresult ;
  
  arg1 = *(QObject **)&self; 
  {
    arg2 = classname;
  }
  result = (bool)((QObject const *)arg1)->inherits((char const *)arg2);
  cresult = result; 
  return cresult;
}


SWIGEXPORT void QObject_deleteLater(QObject * self) {
  QObject *arg1 = (QObject *) 0 ;
  
  arg1 = *(QObject **)&self; 
  (arg1)->deleteLater();
}


#ifdef __cplusplus
}
#endif

