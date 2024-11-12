#!/bin/sh
source "../../common/init.sh"

get https://github.com/LibVNC/x11vnc/archive/"${PV}".tar.gz "${P}".tar.gz
acheck

cd "$S" || exit

PATCHES=(
	"${FILESDIR}"/${P}-crypto.patch # https://github.com/LibVNC/x11vnc/issues/86
	"${FILESDIR}"/${P}-anonymous-ssl.patch # https://github.com/LibVNC/x11vnc/pull/85
	"${FILESDIR}"/${P}-libressl.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

apatch "${PATCHES[@]}"
aautoreconf

cd "${T}" || exit

importpkg X net-dns/avahi dev-libs/openssl

export CFLAGS="${CPPFLAGS} -O2"

doconf

make
make install DESTDIR="${D}"

finalize
