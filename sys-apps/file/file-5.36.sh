#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.astron.com/pub/file/${P}.tar.gz

if [ ! -d ${P} ]; then
	echo "Extracting ${P} ..."
	tar xf ${P}.tar.gz
fi

echo "Compiling ${P} ..."
cd "${T}"

# configure & build
${CHPATH}/${P}/configure >configure.log 2>&1 --prefix=/pkg/main/${PKG}.core.${FILE_VER} --sysconfdir=/etc \
--includedir=/pkg/main/${PKG}.dev.${FILE_VER}/include --libdir=/pkg/main/${PKG}.libs.${FILE_VER} --datarootdir=/pkg/main/${PKG}.core.${FILE_VER}/share \
--mandir=/pkg/main/${PKG}.doc.${FILE_VER}/man --docdir=/pkg/main/${PKG}.doc.${FILE_VER}/doc

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

finalize
cleanup
