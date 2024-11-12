#!/bin/sh
source "../../common/init.sh"

inherit git

fetchgit https://github.com/voipmonitor/sniffer.git "${PV/*.}"
acheck

cd "${S}" || exit

apatch "$FILESDIR/voipmonitor-10.0.20220429.d708463-heapsafe_fix.patch"

DEPS=(
	dev-db/unixODBC
	media-libs/libogg
	media-libs/libvorbis
	net-libs/libpcap
	openssl
	app-arch/snappy
	libxcrypt
	net-misc/curl
	dev-libs/icu
	dev-libs/json-c
	net-analyzer/rrdtool
	dev-libs/glib
	media-libs/libpng
	sci-libs/fftw
	dev-libs/libxml2
	zlib
	app-arch/lzma
	dev-libs/lzo
	net-libs/gnutls
	dev-libs/libgcrypt
	dev-libs/libgpg-error
)

importpkg "${DEPS[@]}"

doconf

make -j4

mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}/sbin"
install voipmonitor "${D}/pkg/main/${PKG}.core.${PVRF}/sbin"

mkdir -pv "${D}/pkg/main/${PKG}.data.${PVRF}/audio"
cp -v samples/audio/* "${D}/pkg/main/${PKG}.data.${PVRF}/audio"

mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}/etc"
cp -v config/voipmonitor.conf "${D}/pkg/main/${PKG}.core.${PVRF}/etc"

finalize
