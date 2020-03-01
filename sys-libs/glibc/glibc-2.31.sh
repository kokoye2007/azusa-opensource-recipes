#!/bin/sh
source "../../common/init.sh"

# fetch xz, compile, build
get http://ftp.jaist.ac.jp/pub/GNU/libc/${P}.tar.xz
acheck

cd "${T}"

# configure & build
doconf --disable-werror --enable-kernel=4.14 --enable-stack-protector=strong --with-headers=/usr/include libc_cv_slibdir=/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX

make
make install DESTDIR="${D}"

archive
