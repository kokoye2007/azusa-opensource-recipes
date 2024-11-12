#!/bin/sh
source "../../common/init.sh"

get https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/"${P}".tar.xz
acheck

cd "${P}" || exit

doconf

make
make install DESTDIR="${D}"

cd "${D}" || exit

mkdir -p "pkg/main/${PKG}.core.${PVRF}" "pkg/main/${PKG}.libs.${PVRF}" "pkg/main/${PKG}.doc.${PVRF}" "pkg/main/${PKG}.dev.${PVRF}"
mv etc var sbin "pkg/main/${PKG}.core.${PVRF}"
mv usr/lib "pkg/main/${PKG}.libs.${PVRF}"
mv usr/include "pkg/main/${PKG}.dev.${PVRF}"
rm -fr usr

finalize
