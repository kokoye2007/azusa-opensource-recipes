#!/bin/sh
source "../../common/init.sh"

get http://mirrors-usa.go-parts.com/gcc/releases/${P}/${P}.tar.xz

cd "${T}"

# configure & build
doconf --enable-languages=c,c++ --disable-bootstrap --disable-libmpx --with-system-zlib

# prepare things a bit
mkdir -p pkg/main/${PKG}.libs.${PVR}/lib64
ln -s lib64 pkg/main/${PKG}.libs.${PVR}/lib

make
make install DESTDIR="${D}"

cd "${D}"

# fix some stuff
mv pkg/main/${PKG}.core.${PVR}/include/* pkg/main/${PKG}.dev.${PVR}/include/
rmdir pkg/main/${PKG}.core.${PVR}/include
#mv pkg/main/lib{32,64} pkg/main/${PKG}.libs.${PVR}/

finalize
