#!/bin/sh
source "../../common/init.sh"

if [ ! -d "/pkg/main/${PKG}.src.${PV}" ]; then
	get https://cdn.kernel.org/pub/linux/kernel/v5.x/${P}.tar.xz

	mkdir -p "${D}/pkg/main"
	mv "${P}" "${D}/pkg/main/${PKG}.src.${PV}"

	archive
	exit
fi

TGT="amd64 386 arm64"

for GOARCH in $TGT; do
	mkdir -p "${T}/$GOARCH"

	cd "${T}/$GOARCH"
	echo "include /pkg/main/${PKG}.src.${PV}/Makefile" >Makefile
	cp -v $FILESDIR/config-${PVR}-$GOARCH ".config"

	echo "Building kernel for $GOARCH..."

	source "$FILESDIR/env.sh"

	# make default old config
	make -s olddefconfig

	# ensure some config
	./source/scripts/config --set-str LOCALVERSION "-azusa" --enable LOCALVERSION_AUTO --set-str DEFAULT_HOSTNAME "localhost"

	FULLVER=`make -s kernelrelease`
	IMGFILE=`make -s image_name`

	echo " * Building `basename "$IMGFILE"`..."

	make -j8 -s `basename "$IMGFILE"`

	echo " * Building modules..."

	make -j8 -s modules #>modules.log 2>&1 </dev/null

	echo " * Copying files..."

	mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}.linux.$GOARCH"
	echo "${PVR}" >"${D}/pkg/main/${PKG}.core.${PVR}.linux.$GOARCH/version.txt"
	cp "$IMGFILE" "${D}/pkg/main/${PKG}.core.${PVR}.linux.$GOARCH/linux-${PVR}.img"
	cp ".config" "${D}/pkg/main/${PKG}.core.${PVR}.linux.$GOARCH/linux-${PVR}.config"
	make modules_install INSTALL_MOD_PATH="${D}/pkg/main/${PKG}.modules.${PVR}.linux.$GOARCH"
	make headers_install INSTALL_HDR_PATH="${D}/pkg/main/${PKG}.dev.${PVR}.linux.$GOARCH"
done

finalize
