#!/bin/sh
source "../../common/init.sh"

get https://pkg-config.freedesktop.org/releases/${P}.tar.gz

if [ ! -d ${P} ]; then
	echo "Extracting ${P} ..."
	tar xf ${P}.tar.gz
fi

echo "Compiling ${P} ..."
cd "${T}"

# configure & build
${CHPATH}/${P}/configure >configure.log 2>&1 --prefix=/pkg/main/${PKG}.core.${PVR} --sysconfdir=/etc \
--includedir=/pkg/main/dev.pkg-config.${PVR}/include --libdir=/pkg/main/${PKG}.libs.${PVR} --datarootdir=/pkg/main/${PKG}.core.${PVR}/share \
--mandir=/pkg/main/${PKG}.doc.${PVR}/man --docdir=/pkg/main/${PKG}.doc.${PVR}/doc \
--enable-languages=c,c++ --disable-bootstrap --disable-libmpx --with-system-zlib

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

finalize
cleanup
