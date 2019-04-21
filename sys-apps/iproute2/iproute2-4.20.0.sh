#!/bin/sh
source "../../common/init.sh"

get https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/${P}.tar.xz

cd "${P}"

doconf

make
make install DESTDIR="${D}"

cd "${D}"

mkdir -p "pkg/main/${PKG}.core.${PVR}" "pkg/main/${PKG}.libs.${PVR}" "pkg/main/${PKG}.doc.${PVR}" "pkg/main/${PKG}.dev.${PVR}"
mv etc var sbin "pkg/main/${PKG}.core.${PVR}"
mv usr/lib "pkg/main/${PKG}.libs.${PVR}"
mv usr/share/{doc,man} "pkg/main/${PKG}.doc.${PVR}"
mv usr/include "pkg/main/${PKG}.dev.${PVR}"
rm -fr usr

finalize
