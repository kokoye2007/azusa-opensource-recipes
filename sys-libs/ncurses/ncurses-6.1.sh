#!/bin/sh
source "../../common/init.sh"

get https://invisible-mirror.net/archives/ncurses/${P}.tar.gz

if [ ! -d ${P} ]; then
	echo "Extracting ${P} ..."
	tar xf ${P}.tar.gz

	sed -i '/LIBTOOL_INSTALL/d' ncurses-${PVR}/c++/Makefile.in
fi

echo "Compiling ${P} ..."
cd "${T}"

# configure & build
${CHPATH}/${P}/configure >configure.log 2>&1 --prefix=/pkg/main/${PKG}.core.${PVR} --sysconfdir=/etc \
--includedir=/pkg/main/${PKG}.dev.${PVR}/include --libdir=/pkg/main/${PKG}.libs.${PVR}/lib --datarootdir=/pkg/main/${PKG}.core.${PVR}/share \
--mandir=/pkg/main/${PKG}.doc.${PVR}/man \
--enable-widec --enable-pc-files --with-shared --without-normal --without-debug

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

cd "${D}"

mv usr/share/pkgconfig "pkg/main/${PKG}.dev.${PVR}/"

finalize
cleanup
