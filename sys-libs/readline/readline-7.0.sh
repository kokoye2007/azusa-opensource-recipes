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
doconf

make
make install DESTDIR="${D}"

cd "${D}"

# move stuff
mv "pkg/main/${PKG}.core.${PVR}/share/readline" "pkg/main/${PKG}.dev.${PVR}/share/"
mv "pkg/main/${PKG}.core.${PVR}/share/info" "pkg/main/${PKG}.doc.${PVR}/info/"
rmdir "pkg/main/${PKG}.core.${PVR}/share"
rmdir "pkg/main/${PKG}.core.${PVR}/bin"
rmdir "pkg/main/${PKG}.core.${PVR}"

finalize
