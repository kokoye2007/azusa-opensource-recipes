#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/readline/${P}.tar.gz

if [ ! -d ${P} ]; then
	echo "Extracting ${P} ..."
	tar xf ${P}.tar.gz
fi

echo "Compiling ${P} ..."
cd "${T}"

# configure & build
${CHPATH}/${P}/configure >configure.log 2>&1 --prefix=/pkg/main/${PKG}.core.${PVR} --sysconfdir=/etc \
--includedir=/pkg/main/${PKG}.dev.${PVR}/include --libdir=/pkg/main/${PKG}.libs.${PVR}/lib --datarootdir=/pkg/main/${PKG}.core.${PVR}/share \
--mandir=/pkg/main/${PKG}.doc.${PVR}/man --docdir=/pkg/main/${PKG}.doc.${PVR}/doc

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

cd ..

# move stuff
mv "dist/pkg/main/${PKG}.core.${PVR}/share/readline" "dist/pkg/main/${PKG}.dev.${PVR}/share/"
mv "dist/pkg/main/${PKG}.core.${PVR}/share/info" "dist/pkg/main/${PKG}.doc.${PVR}/info/"
rmdir "dist/pkg/main/${PKG}.core.${PVR}/share"
rmdir "dist/pkg/main/${PKG}.core.${PVR}/bin"
rmdir "dist/pkg/main/${PKG}.core.${PVR}"

finalize
