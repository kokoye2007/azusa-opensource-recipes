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

# make dev a sysroot for gcc
ln -snfTv "/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.dev.${PVR}/lib$LIB_SUFFIX"
if [ x"$LIB_SUFFIX" != x ]; then
	ln -snfTv "lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.dev.${PVR}/lib"
fi
ln -snfTv . "${D}/pkg/main/${PKG}.dev.${PVR}/usr"

# linux includes
for foo in /pkg/main/sys-kernel.linux.dev/include/*; do
	BASE=`basename "$foo"`
	if [ -d "${D}/pkg/main/${PKG}.dev.${PVR}/include/$BASE" ]; then
		# already a dir there, need to do a cp operation
		cp -rsfT "$foo" "${D}/pkg/main/${PKG}.dev.${PVR}/include/$BASE"
	else
		ln -snfvT "$foo" "${D}/pkg/main/${PKG}.dev.${PVR}/include/$BASE"
	fi
done

# c++ includes + libs
ln -snfv /pkg/main/sys-libs.libcxx.dev/include/c++ "${D}/pkg/main/${PKG}.dev.${PVR}/include/"
ln -snfvT /pkg/main/sys-libs.libcxx.libs/lib$LIB_SUFFIX/libc++.so "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX/libc++.so"

# add link to ld.so.conf and ld.so.cache since binutils will be looking for it here
mkdir "${D}/pkg/main/${PKG}.dev.${PVR}/etc"
ln -snf /pkg/main/azusa.symlinks.core/etc/ld.so.* "${D}/pkg/main/${PKG}.dev.${PVR}/etc"

archive
