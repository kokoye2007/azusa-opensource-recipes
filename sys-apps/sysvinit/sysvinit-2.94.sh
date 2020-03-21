#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.nongnu.org/releases/sysvinit/${P}.tar.xz

cd "${P}"
patch -Np1 -i "$FILESDIR/sysvinit-2.94-consolidated-4.patch"


make
make install ROOT="${D}/pkg/main/${PKG}.core.${PVRF}"

cd "${D}"
# move stuff around
mkdir "pkg/main/${PKG}.doc.${PVRF}"
mkdir "pkg/main/${PKG}.dev.${PVRF}"
mv "pkg/main/${PKG}.core.${PVRF}/usr/share/man" "pkg/main/${PKG}.doc.${PVRF}"
rmdir "pkg/main/${PKG}.core.${PVRF}/usr/share"
mv "pkg/main/${PKG}.core.${PVRF}/usr/include" "pkg/main/${PKG}.dev.${PVRF}"
rmdir "pkg/main/${PKG}.core.${PVRF}/usr/bin"
rmdir "pkg/main/${PKG}.core.${PVRF}/usr"

finalize
