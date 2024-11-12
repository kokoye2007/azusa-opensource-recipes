#!/bin/sh
source "../../common/init.sh"

MY_PV="${PV/_beta/-beta}"
MY_P="LuaJIT-${MY_PV}"
get https://luajit.org/download/"${MY_P}".tar.gz
acheck

cd "${S}" || exit

apatch "$FILESDIR/CVE-2020-15890.patch" "$FILESDIR/luajit-2-ldconfig.patch"

MAKEOPTS=(
	Q=
	PREFIX="$(apfx core)"
	MULTILIB=lib$LIB_SUFFIX
	DESTDIR="$D"
	CFLAGS=""
	LDFLAGS=""
	HOST_CFLAGS="${CPPFLAGS}"
	HOST_LDFLAGS="${LDFLAGS}"
	STATIC_CC="gcc"
	DYNAMIC_CC="gcc -fPIC"
	TARGET_LD="gcc"
	TARGET_CFLAGS="${CPPFLAGS}"
	TARGET_LDFLAGS="${LDFLAGS}"
	TARGET_AR="ar rcus"
	BUILDMODE=mixed
	TARGET_STRIP="true"
	INSTALL_LIB="${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
)

make "${MAKEOPTS[@]}" XCFLAGS=-DLUAJIT_ENABLE_LUA52COMPAT
make "${MAKEOPTS[@]}" install

finalize
