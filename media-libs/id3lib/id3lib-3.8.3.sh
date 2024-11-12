#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/"${PN}"/"${P/_}".tar.gz
acheck

cd "$S" || exit

PATCHES=(
	"${FILESDIR}"/${P}-zlib.patch
	"${FILESDIR}"/${P}-test_io.patch
	"${FILESDIR}"/${P}-autoconf259.patch
	"${FILESDIR}"/${P}-doxyinput.patch
	"${FILESDIR}"/${P}-unicode16.patch
	"${FILESDIR}"/${P}-gcc-4.3.patch
	"${FILESDIR}"/${P}-missing_nullpointer_check.patch
	"${FILESDIR}"/${P}-security.patch
)

apatch "${PATCHES[@]}"
aautoreconf

cd "${T}" || exit

importpkg zlib

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
