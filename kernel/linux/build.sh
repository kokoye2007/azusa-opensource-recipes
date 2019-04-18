#!/bin/sh
set -e

KERNEL_VERSION=5.0.7
BASEDIR=`pwd`
ARCH=`uname -m`
OS=`uname -s | tr A-Z a-z`

case $ARCH in
	x86_64)
		ARCH=amd64
		;;
esac

if [ ! -f linux-${KERNEL_VERSION}.tar.xz ]; then
	wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-${KERNEL_VERSION}.tar.xz
fi

if [ ! -d linux-${KERNEL_VERSION} ]; then
	echo "Extracting..."
	tar xf linux-${KERNEL_VERSION}.tar.xz
fi

cd linux-${KERNEL_VERSION}

if [ ! -f .config ]; then
	cp ../config-${KERNEL_VERSION} ./.config
fi

echo "Compiling"
make >make.log 2>&1 -j4

echo "Building dist..."
FULLVER=`make -s kernelrelease`
IMGFILE=`make -s image_name`

mkdir -p "${BASEDIR}/dist/kernel"
cp "$IMGFILE" "${BASEDIR}/dist/kernel/kernel-${FULLVER}.img"
cp ".config" "${BASEDIR}/dist/kernel/kernel-${FULLVER}.config"
make modules_install INSTALL_MOD_PATH="${BASEDIR}/dist/modules"
make headers_install INSTALL_HDR_PATH="${BASEDIR}/dist/dev"

cd "$BASEDIR"

mksquashfs dist/kernel "dist/kernel.linux.core.${KERNEL_VERSION}.${OS}.${ARCH}.squashfs" -all-root
mksquashfs dist/modules "dist/kernel.linux.modules.${KERNEL_VERSION}.${OS}.${ARCH}.squashfs" -all-root
mksquashfs dist/dev "dist/kernel.linux.dev.${KERNEL_VERSION}.${OS}.${ARCH}.squashfs" -all-root

if [ x"$HSM" != x ]; then
	tpkg-convert dist/*.squashfs
fi
