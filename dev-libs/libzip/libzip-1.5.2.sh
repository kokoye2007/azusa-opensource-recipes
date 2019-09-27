#!/bin/sh
source "../../common/init.sh"

get https://www.nih.at/libzip/${P}.tar.xz
acheck

importpkg zlib app-arch/bzip2

cd "${T}"

cmake "${CHPATH}/${P}" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR} -DBUILD_SHARED_LIBS=ON $(importcmake app-arch/bzip2 sys-libs/zlib)

make
make install DESTDIR="${D}"

finalize
