#!/bin/sh
source "../../common/init.sh"

get http://mirrors-usa.go-parts.com/gcc/releases/${P}/${P}.tar.xz

if [ ! -d ${P} ]; then
	echo "Extracting ${P} ..."
	tar xf ${P}.tar.xz
fi

echo "Compiling ${P} ..."
cd "${T}"

# configure & build
${CHPATH}/${P}/configure >configure.log 2>&1 --prefix=/pkg/main/${PKG}.core.${PVR} --sysconfdir=/etc \
--includedir=/pkg/main/${PKG}.dev.${PVR}/include --libdir=/pkg/main/${PKG}.libs.${PVR} --datarootdir=/pkg/main/${PKG}.core.${PVR}/share \
--mandir=/pkg/main/${PKG}.doc.${PVR}/man --docdir=/pkg/main/${PKG}.doc.${PVR}/doc \
--enable-languages=c,c++ --disable-bootstrap --disable-libmpx --with-system-zlib

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

cd "${D}"

# fix some stuff
mv pkg/main/${PKG}.core.${PVR}/include/* pkg/main/${PKG}.dev.${PVR}/include/
rmdir pkg/main/${PKG}.core.${PVR}/include
mv pkg/main/lib{32,64} pkg/main/${PKG}.libs.${PVR}/

finalize
cleanup
