#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.gnu.org/gnu/gdbm/${P}.tar.gz

if [ ! -d ${P} ]; then
	echo "Extracting ${P} ..."
	tar xf ${P}.tar.gz
fi

echo "Compiling ${P} ..."
cd "${T}"

# configure & build
${CHPATH}/${P}/configure >configure.log 2>&1 --prefix=/usr --sysconfdir=/etc --exec-prefix=/pkg/main/${PKG}.core.${PVR} \
--includedir=/pkg/main/${PKG}.dev.${PVR}/include --libdir=/pkg/main/${PKG}.libs.${PVR}/lib --datarootdir=/pkg/main/${PKG}.core.${PVR} \
--mandir=/pkg/main/${PKG}.doc.${PVR}/man --docdir=/pkg/main/${PKG}.doc.${PVR}/doc \
--enable-libgdbm-compat

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

finalize
