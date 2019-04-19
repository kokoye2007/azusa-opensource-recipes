#!/bin/sh
set -e

BUSYBOX_VER=1.30.1
BASEDIR=`pwd`
PKG="core.busybox"

source "$BASEDIR/../../common/init.sh"

get https://busybox.net/downloads/busybox-${BUSYBOX_VER}.tar.bz2

if [ ! -d busybox-${BUSYBOX_VER} ]; then
	echo "Extracting busybox-${BUSYBOX_VER} ..."
	tar xf busybox-${BUSYBOX_VER}.tar.bz2
fi

exit

echo "Compiling busybox-${BUSYBOX_VER} ..."
cp config-${BUSYBOX_VER} busybox-${BUSYBOX_VER}

cd busybox-${BUSYBOX_VER}
make >make.log 2>&1
make >make_install.log 2>&1 install

cd ..

rsync -a busybox-${BUSYBOX_VER}/_install/ "dist/pkg/main/core.busybox.${BUSYBOX_VER}/"

echo "Building squashfs..."

# build squashfs files

squash "dist/pkg/main/core.busybox.${BUSYBOX_VER}"

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
