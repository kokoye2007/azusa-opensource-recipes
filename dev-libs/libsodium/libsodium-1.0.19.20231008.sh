#!/bin/sh
source "../../common/init.sh"

sodium_get() {
	local MY_PV="${PV%.*}"
	local CURV="$(TZ=GMT date --date="$(curl -s --head "https://download.libsodium.org/libsodium/releases/libsodium-${MY_PV}-stable.tar.gz" | grep last-modified | cut -d: -f2-)" '+%Y%m%d')"
	local FULLV="${MY_PV}.${CURV}"
	if [ x"$PV" != x"$FULLV" ]; then
		echo "Invalid request, libsodium-$PV is not available, please rename to libsodium-$FULLV"
		exit 1
	fi
	wget -O "libsodium-$FULLV.tar.gz" "https://download.libsodium.org/libsodium/releases/libsodium-${MY_PV}-stable.tar.gz"
}

DOWNLOAD_OVERRIDE=sodium_get get https://download.libsodium.org/libsodium/releases/${P}.tar.gz
acheck

cd "${T}"

doconf --enable-asm

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
