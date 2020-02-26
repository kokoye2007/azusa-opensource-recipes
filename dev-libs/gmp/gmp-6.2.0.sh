#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/gmp/${P}.tar.xz
acheck

cd "${T}"

# configure & build
doconf --enable-cxx --disable-static --build=x86_64-unknown-linux-gnu

make
make install DESTDIR="${D}"

cd "${D}"

mv pkg/main/${PKG}.core.${PVR}/include/gmp.h pkg/main/${PKG}.dev.${PVR}/include/
rmdir pkg/main/${PKG}.core.${PVR}/include

mkdir -p pkg/main/${PKG}.doc.${PVR}
mv pkg/main/${PKG}.core.${PVR}/share/info pkg/main/${PKG}.doc.${PVR}
rmdir pkg/main/${PKG}.core.${PVR}/share
rmdir pkg/main/${PKG}.core.${PVR}

finalize
