#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.nongnu.org/releases/sysvinit/${P}.tar.xz
acheck

cd "${S}"

make
make install ROOT="${D}/pkg/main/${PKG}.core.${PVRF}"

cd "${D}"
# move stuff around
mkdir "pkg/main/${PKG}.doc.${PVRF}"
mkdir "pkg/main/${PKG}.dev.${PVRF}"
mv "pkg/main/${PKG}.core.${PVRF}/usr/share/man" "pkg/main/${PKG}.doc.${PVRF}"
rmdir "pkg/main/${PKG}.core.${PVRF}/usr/share"
mv "pkg/main/${PKG}.core.${PVRF}/usr/include" "pkg/main/${PKG}.dev.${PVRF}"
mv -v "pkg/main/${PKG}.core.${PVRF}/usr/bin"/* "pkg/main/${PKG}.core.${PVRF}/bin"
rmdir "pkg/main/${PKG}.core.${PVRF}/usr/bin"
rmdir "pkg/main/${PKG}.core.${PVRF}/usr"

finalize
