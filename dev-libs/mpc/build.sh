#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/mpc/${P}.tar.gz

if [ ! -d ${P} ]; then
	echo "Extracting ${P} ..."
	tar xf ${P}.tar.gz
fi

echo "Compiling ${P} ..."
cd "${T}"

# configure & build
${CHPATH}/${P}/configure >configure.log 2>&1 --prefix=/pkg/main/${PKG}.core.${PVR} --sysconfdir=/etc \
--includedir=/pkg/main/${PKG}.dev.${PVR}/include --libdir=/pkg/main/${PKG}.libs.${PVR}/lib --datarootdir=/pkg/main/${PKG}.core.${PVR}/share \
--mandir=/pkg/main/${PKG}.doc.${PVR}/man --docdir=/pkg/main/${PKG}.doc.${PVR}/doc \
--disable-static --with-mpfr-include=/pkg/main/dev-libs.mpfr.dev/include --with-mpfr-lib=/pkg/main/dev-libs.mpfr.libs/lib \
--with-gmp-include=/pkg/main/dev-libs.gmp.dev/include --with-gmp-lib=/pkg/main/dev-libs.gmp.libs/lib

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

