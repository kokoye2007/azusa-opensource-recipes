#!/bin/sh
source "../../common/init.sh"

# fetch xz, compile, build
get http://ftp.jaist.ac.jp/pub/GNU/libc/${P}.tar.xz

cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

cd "${D}"

# move some stuff
mv etc "pkg/main/${PKG}.core.${PVR}"
#mv sbin/* "pkg/main/${PKG}.core.${PVR}/sbin"
#mv lib* "pkg/main/${PKG}.libs.${PVR}"
#mv var "pkg/main/${PKG}.core.${PVR}"
#rmdir sbin

archive
