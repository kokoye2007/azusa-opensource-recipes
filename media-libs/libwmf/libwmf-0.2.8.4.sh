#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/wvware/${P}.tar.gz
acheck

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-CVE-2015-0848+CVE-2015-4588.patch
	"${FILESDIR}"/${P}-CVE-2015-4695.patch
	"${FILESDIR}"/${P}-CVE-2015-4696.patch
	"${FILESDIR}"/${P}-gdk-pixbuf.patch
	"${FILESDIR}"/${P}-intoverflow.patch
	"${FILESDIR}"/${P}-libpng-1.5.patch
	"${FILESDIR}"/${P}-pngfix.patch
	"${FILESDIR}"/${P}-use-freetype2-pkg-config.patch
	"${FILESDIR}"/${P}-use-system-fonts.patch
	)

cd "${P}"

apatch "${PATCHES[@]}"
aautoreconf

cd "${T}"

importpkg zlib

doconf

make
make install DESTDIR="${D}"

finalize
