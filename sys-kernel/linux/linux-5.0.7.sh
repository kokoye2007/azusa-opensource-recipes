#!/bin/sh
source "../../common/init.sh"

get https://cdn.kernel.org/pub/linux/kernel/v5.x/${P}.tar.xz

if [ ! -d ${P} ]; then
	echo "Extracting..."
	tar xf ${P}.tar.xz
fi

cd ${P}

if [ ! -f .config ]; then
	cp $FILESDIR/config-${PVR} ./.config
fi

echo "Compiling"
make >make.log 2>&1 -j4

echo "Building dist..."
FULLVER=`make -s kernelrelease`
IMGFILE=`make -s image_name`

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}"
cp "$IMGFILE" "${D}/pkg/main/${PKG}.core.${PVR}/linux-${PVR}.img"
cp ".config" "${D}/pkg/main/${PKG}.core.${PVR}/linux-${PVR}.config"
make modules_install INSTALL_MOD_PATH="${D}/pkg/main/${PKG}.modules.${PVR}"
make headers_install INSTALL_HDR_PATH="${D}/pkg/main/${PKG}.dev.${PVR}"

finalize
cleanup
