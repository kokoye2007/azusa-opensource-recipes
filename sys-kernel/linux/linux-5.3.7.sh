#!/bin/sh
source "../../common/init.sh"

if [ ! -d "/pkg/main/${PKG}.src.${PV}" ]; then
	get https://cdn.kernel.org/pub/linux/kernel/v5.x/${P}.tar.xz

	mkdir -p "${D}/pkg/main"
	mv "${P}" "${D}/pkg/main/${PKG}.src.${PV}"

	finalize
	exit
fi

cd "${T}"
cp -v $FILESDIR/config-${PVR} ".config"
echo "include /pkg/main/${PKG}.src.${PV}/Makefile" >Makefile

echo "Building kernel..."

make -j8 bzImage >kernel.log 2>&1

echo "Building modules..."

make -j8 modules >modules.log 2>&1

echo "Running dist..."
FULLVER=`make -s kernelrelease`
IMGFILE=`make -s image_name`

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}"
echo "${PVR}" >"${D}/pkg/main/${PKG}.core.${PVR}/version.txt"
cp "$IMGFILE" "${D}/pkg/main/${PKG}.core.${PVR}/linux-${PVR}.img"
cp ".config" "${D}/pkg/main/${PKG}.core.${PVR}/linux-${PVR}.config"
make modules_install INSTALL_MOD_PATH="${D}/pkg/main/${PKG}.modules.${PVR}"
make headers_install INSTALL_HDR_PATH="${D}/pkg/main/${PKG}.dev.${PVR}"

finalize
