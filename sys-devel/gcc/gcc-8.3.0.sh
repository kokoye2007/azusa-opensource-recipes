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
${CHPATH}/${P}/configure >configure.log 2>&1 --prefix=/pkg/main/${PKG}.core.${GCC_VER} --sysconfdir=/etc \
--includedir=/pkg/main/${PKG}.dev.${GCC_VER}/include --libdir=/pkg/main/${PKG}.libs.${GCC_VER} --datarootdir=/pkg/main/${PKG}.core.${GCC_VER}/share \
--mandir=/pkg/main/${PKG}.doc.${GCC_VER}/man --docdir=/pkg/main/${PKG}.doc.${GCC_VER}/doc \
--enable-languages=c,c++ --disable-bootstrap --disable-libmpx --with-system-zlib

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

cd "${D}"

# fix some stuff
mv usr/include/* pkg/main/${PKG}.dev.${GCC_VER}/include/
mv pkg/main/lib{32,64} pkg/main/${PKG}.libs.${GCC_VER}/

finalize
