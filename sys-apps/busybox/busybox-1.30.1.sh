#!/bin/sh
source "../../common/init.sh"

get https://busybox.net/downloads/${P}.tar.bz2
acheck

echo "Compiling ${P} ..."
cd "${P}"
cp $FILESDIR/config-${PV} .config

make
make install

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}/"
rsync -a ./_install/ "${D}/pkg/main/${PKG}.core.${PVR}/"
mkdir -p "${D}/pkg/main/${PKG}.doc.${PVR}/"
rsync -av --progress ./examples "${D}/pkg/main/${PKG}.doc.${PVR}/"

finalize
