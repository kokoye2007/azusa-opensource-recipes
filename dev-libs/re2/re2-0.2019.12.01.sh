#!/bin/sh
source "../../common/init.sh"

# Different date format used upstream.
RE2_VER=${PV#0.}
RE2_VER=${RE2_VER//./-}

get https://github.com/google/re2/archive/${RE2_VER}.tar.gz re2-${RE2_VER}.tar.gz
acheck

cd "${S}"

MAKEPARAMS=(
	SONAME="azusa-${PV}"
	DESTDIR="${D}"
	prefix="/pkg/main/${PKG}.core.${PVR}"
	libdir="/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX"
)

make ${MAKEPARAMS[@]}
make install ${MAKEPARAMS[@]}

finalize
