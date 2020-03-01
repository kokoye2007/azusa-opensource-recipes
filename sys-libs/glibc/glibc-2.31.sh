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

# link lib into dev so dev can be used as sysroot value
ln -snfTv "/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.dev.${PVR}/lib$LIB_SUFFIX"
if [ x"$LIB_SUFFIX" != x ]; then
	ln -snfTv "lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.dev.${PVR}/lib"
fi
ln -snfTv . "${D}/pkg/main/${PKG}.dev.${PVR}/usr"

archive
