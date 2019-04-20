#!/bin/sh
source "../../common/init.sh"

get https://tukaani.org/xz/${P}.tar.bz2

if [ ! -d ${P} ]; then
	echo "Extracting ${P} ..."
	tar xf ${P}.tar.bz2
fi

echo "Compiling ${P} ..."
if [ -d work ]; then
	rm -fr work
fi
mkdir work
cd work

# configure & build
../${P}/configure >configure.log 2>&1 --prefix=/pkg/main/${PKG}.core.${PVR} --sysconfdir=/etc \
--includedir=/pkg/main/${PKG}.dev.${PVR}/include --libdir=/pkg/main/${PKG}.libs.${PVR}/lib --datarootdir=/pkg/main/${PKG}.core.${PVR}/share \
--mandir=/pkg/main/${PKG}.doc.${PVR}/man --docdir=/pkg/main/${PKG}.doc.${PVR}/doc

make >make.log 2>&1
mkdir -p "${CHPATH}/dist"
make >make_install.log 2>&1 install DESTDIR="${CHPATH}/dist"

cd "${CHPATH}"

mkdir -p "dist/pkg/main/${PKG}.dev.${PVR}/lib"
mv "dist/pkg/main/${PKG}.libs.${PVR}/lib"/*.a "dist/pkg/main/${PKG}.dev.${PVR}/lib"

finalize

