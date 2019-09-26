#!/bin/sh
source "../../common/init.sh"

get https://github.com/libgd/libgd/releases/download/${P}/lib${P}.tar.xz

cd "lib${P}"

patch -p1 <"$FILESDIR/${P}-ossfuzz5700.patch"
patch -p1 <"$FILESDIR/${P}-CVE-2018-5711.patch"
patch -p1 <"$FILESDIR/${P}-CVE-2018-1000222.patch"
patch -p1 <"$FILESDIR/${P}-CVE-2019-6977.patch"
patch -p1 <"$FILESDIR/${P}-CVE-2019-6978.patch"

cd "${T}"

importpkg libjpeg libwebp

doconf --disable-static --disable-werror --without-x --without-liq --with-zlib --with-png --with-freetype --with-fontconfig --with-jpeg=/pkg/main/media-libs.libjpeg-turbo.dev --with-xpm --with-tiff --with-webp

make
make install DESTDIR="${D}"

finalize
