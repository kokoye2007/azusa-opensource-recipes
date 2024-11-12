#!/bin/sh
source "../../common/init.sh"

if [ ! -d "/pkg/main/${PKG}.src.${PV}.linux.any" ]; then
	echo "Dir /pkg/main/${PKG}.src.${PV}.linux.any not found"
	get https://cdn.kernel.org/pub/linux/kernel/v5.x/"${P}".tar.xz

	mkdir -p "${D}/pkg/main"
	mv "${P}" "${D}/pkg/main/${PKG}.src.${PV}.linux.any"

	archive
	exit
fi

TGT="amd64 386" # arm64"
acheck

for GOARCH in $TGT; do
	mkdir -p "${T}/$GOARCH"

	cd "${T}/$GOARCH" || exit
	echo "include /pkg/main/${PKG}.src.${PV}.linux.any/Makefile" >Makefile
	cp -v "$FILESDIR"/config-"${PV}"-"$GOARCH" ".config"

	echo "Building kernel for $GOARCH..."

	source "$FILESDIR/env.sh"

	# make default old config
	make -s olddefconfig

	# ensure some config
	./source/scripts/config --set-str LOCALVERSION "-azusa" --enable LOCALVERSION_AUTO --set-str DEFAULT_HOSTNAME "localhost"

	# re-copy file
	cp .config "$FILESDIR"/config-"${PV}"-"$GOARCH"

	FULLVER=$(make -s kernelrelease)
	IMGFILE=$(make -s image_name)

	echo " * Building $(basename "$IMGFILE")..."

	make -j"$NPROC" -s $(basename "$IMGFILE")

	echo " * Building modules..."

	make -j"$NPROC" -s modules #>modules.log 2>&1 </dev/null

	echo " * Copying files..."

	mkdir -p "${D}/pkg/main/${PKG}.core.${PV}.linux.$GOARCH"
	echo "${PV}" >"${D}/pkg/main/${PKG}.core.${PV}.linux.$GOARCH/version.txt"
	echo "${FULLVER}" >"${D}/pkg/main/${PKG}.core.${PV}.linux.$GOARCH/release.txt"
	basename "${IMGFILE}" >"${D}/pkg/main/${PKG}.core.${PV}.linux.$GOARCH/image.txt"
	cp "$IMGFILE" "${D}/pkg/main/${PKG}.core.${PV}.linux.$GOARCH/linux-${PV}.img"
	cp ".config" "${D}/pkg/main/${PKG}.core.${PV}.linux.$GOARCH/linux-${PV}.config"
	make -s modules_install INSTALL_MOD_PATH="${D}/pkg/main/${PKG}.modules.${PV}.linux.$GOARCH"
	make -s headers_install INSTALL_HDR_PATH="${D}/pkg/main/${PKG}.dev.${PV}.linux.$GOARCH"
done

finalize
