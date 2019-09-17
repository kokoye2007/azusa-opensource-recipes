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

# fix: create a symlink to libs/lib64 in core so ldd works
ln -snf /pkg/main/sys-libs.glibc.libs.${PVR}/lib64 "pkg/main/${PKG}.core.${PVR}/lib64"

#mv sbin/* "pkg/main/${PKG}.core.${PVR}/sbin"
#mv lib* "pkg/main/${PKG}.libs.${PVR}"
#mv var "pkg/main/${PKG}.core.${PVR}"
#rmdir sbin

archive
