#!/bin/sh
source "../../common/init.sh"

# fetch xz, compile, build
get http://ftp.jaist.ac.jp/pub/GNU/libc/${P}.tar.xz
acheck

cd "${T}"

# configure & build
doconf --disable-werror --enable-kernel=4.19 --enable-stack-protector=strong --with-headers=/usr/include libc_cv_slibdir=/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX

make
make install DESTDIR="${D}"

cd "${D}"

# move some stuff
mv etc "pkg/main/${PKG}.core.${PVR}"

# fix: create a symlink to lib in core so ldd works
#ln -snf lib "pkg/main/${PKG}.core.${PVR}/lib64"

#mv sbin/* "pkg/main/${PKG}.core.${PVR}/sbin"
#mv lib* "pkg/main/${PKG}.libs.${PVR}"
#mv var "pkg/main/${PKG}.core.${PVR}"
#rmdir sbin

archive
