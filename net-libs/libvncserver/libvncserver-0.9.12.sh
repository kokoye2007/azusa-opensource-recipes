#!/bin/sh
source "../../common/init.sh"

MY_P="LibVNCServer-${PV}"

get https://github.com/LibVNC/"${PN}"/archive/"${MY_P}".tar.gz
acheck

cd "${S}" || exit
PATCHES=(
	"${FILESDIR}"/${P}-cmake-libdir.patch
	"${FILESDIR}"/${P}-pkgconfig-libdir.patch
	"${FILESDIR}"/${P}-libgcrypt.patch
	"${FILESDIR}"/${P}-sparc-unaligned.patch
	"${FILESDIR}"/${P}-CVE-2018-20750.patch
	"${FILESDIR}"/${P}-CVE-2019-15681.patch
	"${FILESDIR}"/${P}-fix-tight-raw-decoding.patch
	"${FILESDIR}"/${P}-fix-shutdown-crash.patch
)
apatch "${PATCHES[@]}"

cd "${T}" || exit

importpkg dev-libs/openssl

export CFLAGS="${CPPFLAGS} -O2"

docmake

make
make install DESTDIR="${D}"

finalize
