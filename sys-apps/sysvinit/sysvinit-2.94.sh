#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.nongnu.org/releases/sysvinit/${P}.tar.xz

cd "${P}"
patch -Np1 -i "$FILESDIR/sysvinit-2.94-consolidated-4.patch"


make
make install ROOT="${D}/pkg/main/${PKG}.core.${PVR}"

cd "${D}"
# move stuff around
mkdir "pkg/main/${PKG}.doc.${PVR}"
mkdir "pkg/main/${PKG}.dev.${PVR}"
mv "pkg/main/${PKG}.core.${PVR}/usr/share/man" "pkg/main/${PKG}.doc.${PVR}"
rmdir "pkg/main/${PKG}.core.${PVR}/usr/share"
mv "pkg/main/${PKG}.core.${PVR}/usr/include" "pkg/main/${PKG}.dev.${PVR}"
rmdir "pkg/main/${PKG}.core.${PVR}/usr/bin"
rmdir "pkg/main/${PKG}.core.${PVR}/usr"

finalize
