#!/bin/sh
source "../../common/init.sh"

get https://cdn.kernel.org/pub/linux/kernel/v5.x/${P}.tar.xz

cd ${P}

cp -v $FILESDIR/config-${PVR} ./.config

make -j8

echo "Building dist..."
FULLVER=`make -s kernelrelease`
IMGFILE=`make -s image_name`

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}"
echo "${PVR}" >"${D}/pkg/main/${PKG}.core.${PVR}/version.txt"
cp "$IMGFILE" "${D}/pkg/main/${PKG}.core.${PVR}/linux-${PVR}.img"
cp ".config" "${D}/pkg/main/${PKG}.core.${PVR}/linux-${PVR}.config"
make modules_install INSTALL_MOD_PATH="${D}/pkg/main/${PKG}.modules.${PVR}"
make headers_install INSTALL_HDR_PATH="${D}/pkg/main/${PKG}.dev.${PVR}"

finalize
