#!/bin/sh
source "../../common/init.sh"

get https://busybox.net/downloads/${P}.tar.bz2

echo "Compiling ${P} ..."
cd "${P}"
cp $FILESDIR/config-${PV} .config

make
make install

mkdir -p "${D}/pkg/main/${PKG}.${PVR}/"
rsync -a ./_install/ "${D}/pkg/main/${PKG}.${PVR}/"

finalize
