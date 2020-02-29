#!/bin/sh
source "../../common/init.sh"

get https://invisible-mirror.net/archives/ncurses/${P}.tar.gz
acheck

sed -i '/LIBTOOL_INSTALL/d' ncurses-${PV}/c++/Makefile.in

cd "${T}"

# configure & build
# NOTE: ncurses doesn't support --docdir

# without widec
callconf --prefix=/pkg/main/${PKG}.core.${PVR} --sysconfdir=/etc \
--includedir=/pkg/main/${PKG}.dev.${PVR}/include --libdir=/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX --datarootdir=/pkg/main/${PKG}.core.${PVR}/share \
--mandir=/pkg/main/${PKG}.doc.${PVR}/man --with-pkg-config --with-pkg-config-libdir=/pkg/main/${PKG}.dev.${PVR}/pkgconfig \
--disable-widec --enable-pc-files --with-shared --without-normal --without-debug --with-termlib

make
make install DESTDIR="${D}"

make distclean

# with widec
callconf --prefix=/pkg/main/${PKG}.core.${PVR} --sysconfdir=/etc \
--includedir=/pkg/main/${PKG}.dev.${PVR}/include/ncursesw --libdir=/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX --datarootdir=/pkg/main/${PKG}.core.${PVR}/share \
--mandir=/pkg/main/${PKG}.doc.${PVR}/man --with-pkg-config --with-pkg-config-libdir=/pkg/main/${PKG}.dev.${PVR}/pkgconfig \
--enable-widec --enable-pc-files --with-shared --without-normal --without-debug --with-termlib

make
make install DESTDIR="${D}"

cd "${D}"

#cd "pkg/main/${PKG}.libs.${PVR}/lib64"
#for lib in ncurses form panel menu ; do
	# workaround for bash
	#echo "INPUT(-l${lib}w)" > lib${lib}.so
	#echo "INPUT(-l${lib}w)" > lib${lib}.so.6
#done

finalize
