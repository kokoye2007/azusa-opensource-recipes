#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/mpfr/${P}.tar.xz

if [ ! -d ${P} ]; then
	echo "Extracting ${P} ..."
	tar xf ${P}.tar.xz
fi

echo "Compiling ${P} ..."
cd "${T}"

# configure & build
${CHPATH}/${P}/configure >configure.log 2>&1 --prefix=/pkg/main/${PKG}.core.${MPFR_VER} --sysconfdir=/etc \
--includedir=/pkg/main/${PKG}.dev.${MPFR_VER}/include --libdir=/pkg/main/${PKG}.libs.${MPFR_VER}/lib --datarootdir=/pkg/main/${PKG}.core.${MPFR_VER}/share \
--mandir=/pkg/main/${PKG}.doc.${MPFR_VER}/man --docdir=/pkg/main/${PKG}.doc.${MPFR_VER}/doc \
--disable-static --enable-thread-safe

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

finalize
cleanup
