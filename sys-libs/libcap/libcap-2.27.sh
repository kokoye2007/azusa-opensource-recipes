#!/bin/sh
source "../../common/init.sh"

get https://git.kernel.org/pub/scm/libs/libcap/libcap.git/snapshot/${P}.tar.gz

sed -i '/install.*STALIBNAME/d' ${P}/libcap/Makefile

cd ${P}

# configure & build
make
make install RAISE_SETFCAP=no prefix="${D}/work"

cd "${D}"

mkdir -p "pkg/main/${PKG}.libs.${PVR}" "pkg/main/${PKG}.dev.${PVR}" "pkg/main/${PKG}.core.${PVR}" "pkg/main/${PKG}.doc.${PVR}"
mv work/sbin "pkg/main/${PKG}.core.${PVR}"
mv work/include "pkg/main/${PKG}.dev.${PVR}"
mv work/lib64/pkgconfig "pkg/main/${PKG}.dev.${PVR}"
mv work/lib64 "pkg/main/${PKG}.libs.${PVR}"
mv work/share/man "pkg/main/${PKG}.doc.${PVR}"

finalize
