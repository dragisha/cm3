#!/bin/sh

GCC_BACKEND=${GCC_BACKEND:-no}
WIN32=${WIN32:-yes}
M3GDB=${M3GDB:-no}

# base libraries and compiler
PKGS=""
PKGS="${PKGS} m3-libs/m3core"
PKGS="${PKGS} m3-libs/libm3"
PKGS="${PKGS} m3-sys/m3middle"
[ "${WIN32}" = yes ] && PKGS="${PKGS} m3-sys/m3objfile"
PKGS="${PKGS} m3-sys/m3linker"
[ "${GCC_BACKEND}" != yes ] && PKGS="${PKGS} m3-sys/m3back"
[ "${GCC_BACKEND}" != yes ] && PKGS="${PKGS} m3-sys/m3staloneback"
PKGS="${PKGS} m3-sys/m3front"
PKGS="${PKGS} m3-sys/m3quake"
[ "${GCC_BACKEND}" = yes ] && PKGS="${PKGS} m3-sys/m3cc"
PKGS="${PKGS} m3-sys/cm3"

# cm3 tools (mostly for win32)
# PKGS="${PKGS} m3-sys/m3loader"
PKGS="${PKGS} m3-sys/m3scanner"
PKGS="${PKGS} m3-sys/m3tools"
[ "${WIN32}" = yes ] && PKGS="${PKGS} m3-sys/mklib"
[ "${WIN32}" = yes ] && PKGS="${PKGS} m3-sys/dll2lib"
[ "${WIN32}" = yes ] && PKGS="${PKGS} m3-sys/fix_nl"
[ "${WIN32}" = yes ] && PKGS="${PKGS} m3-sys/libdump"
PKGS="${PKGS} m3-sys/m3cgcat"
PKGS="${PKGS} m3-sys/m3cggen"
[ "${M3GDB}" = yes ] && PKGS="${PKGS} m3-sys/m3gdb"

# more libraries
PKGS="${PKGS} m3-libs/bitvector"
PKGS="${PKGS} m3-libs/digraph"
#PKGS="${PKGS} m3-libs/dps" # needs special postscript support
PKGS="${PKGS} m3-libs/parseparams"
PKGS="${PKGS} m3-libs/realgeometry"
PKGS="${PKGS} m3-libs/set"
PKGS="${PKGS} m3-libs/slisp"
PKGS="${PKGS} m3-libs/sortedtableextras"
PKGS="${PKGS} m3-libs/table-list"
#PKGS="${PKGS} m3-libs/tcl" # needs tcl library
PKGS="${PKGS} m3-libs/tempfiles"

echo ./pkgmap.sh $@ ${PKGS}
exec ./pkgmap.sh $@ ${PKGS}
