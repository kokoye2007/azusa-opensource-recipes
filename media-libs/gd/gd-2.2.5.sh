#!/bin/sh
source "../../common/init.sh"

get https://github.com/libgd/libgd/releases/download/${P}/lib${P}.tar.xz
acheck

cd "lib${P}"

PATCHES=(
	"$FILESDIR/${P}-ossfuzz5700.patch"
	"$FILESDIR/${P}-CVE-2018-5711.patch"
	"$FILESDIR/${P}-CVE-2018-1000222.patch"
	"$FILESDIR/${P}-CVE-2019-6977.patch"
	"$FILESDIR/${P}-CVE-2019-6978.patch"
)
apatch $PATCHES
aautoreconf

cd "${T}"

importpkg libjpeg libwebp uuid app-arch/bzip2 liblzma libbsd

doconf --disable-static --disable-werror --without-x --without-liq --with-zlib --with-png --with-freetype --with-fontconfig --with-jpeg=/pkg/main/media-libs.libjpeg-turbo.dev --with-xpm --with-tiff --with-webp

make
make install DESTDIR="${D}"

finalize
