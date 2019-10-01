#!/bin/sh
source "../../common/init.sh"

get https://www.musl-libc.org/releases/${P}.tar.gz
acheck

cd "${T}"

# we install musl in a subdirectory to avoid headers from conflicting with glibc
callconf --prefix=/pkg/main/${PKG}.dev.${PVR}/musl --exec-prefix=/pkg/main/${PKG}.core.${PVR} --syslibdir=/pkg/main/${PKG}.dev.${PVR}/lib$LIB_SUFFIX --enable-wrapper=all

make -j8
make install DESTDIR="${D}"

finalize
