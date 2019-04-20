#!/bin/sh
source "../../common/init.sh"

get https://busybox.net/downloads/${P}.tar.bz2

if [ ! -d ${P} ]; then
	echo "Extracting ${P} ..."
	tar xf ${P}.tar.bz2
fi

echo "Compiling ${P} ..."
cd "${P}"
cp $FILESDIR/config-${PV} .config

make >make.log 2>&1
make >make_install.log 2>&1 install

mkdir -p "${D}/pkg/main/${PKG}.${PVR}/"
rsync -a ./_install/ "${D}/pkg/main/${PKG}.${PVR}/"

finalize
cleanup
