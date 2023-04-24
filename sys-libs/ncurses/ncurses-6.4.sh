#!/bin/sh
source "../../common/init.sh"

get https://invisible-mirror.net/archives/ncurses/${P}.tar.gz
acheck

sed -i '/LIBTOOL_INSTALL/d' ncurses-${PV}/c++/Makefile.in

cd "${T}"

# configure & build
# NOTE: ncurses doesn't support --docdir

# without widec
callconf --prefix=/pkg/main/${PKG}.core.${PVRF} --sysconfdir=/etc \
--includedir=/pkg/main/${PKG}.dev.${PVRF}/include --libdir=/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX --datarootdir=/pkg/main/${PKG}.core.${PVRF}/share \
--mandir=/pkg/main/${PKG}.doc.${PVRF}/man --with-pkg-config --with-pkg-config-libdir=/pkg/main/${PKG}.dev.${PVRF}/pkgconfig \
--disable-widec --enable-pc-files --with-shared --without-normal --without-debug --with-termlib

make
make install DESTDIR="${D}"

make distclean

# with widec
callconf --prefix=/pkg/main/${PKG}.core.${PVRF} --sysconfdir=/etc \
--includedir=/pkg/main/${PKG}.dev.${PVRF}/include/ncursesw --libdir=/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX --datarootdir=/pkg/main/${PKG}.core.${PVRF}/share \
--mandir=/pkg/main/${PKG}.doc.${PVRF}/man --with-pkg-config --with-pkg-config-libdir=/pkg/main/${PKG}.dev.${PVRF}/pkgconfig \
--enable-widec --enable-pc-files --with-shared --without-normal --without-debug --with-termlib

make
make install DESTDIR="${D}"

cd "${D}"

finalize
