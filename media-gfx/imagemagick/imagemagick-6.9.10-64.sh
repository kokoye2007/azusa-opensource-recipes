#!/bin/sh
source "../../common/init.sh"

get https://www.imagemagick.org/download/releases/ImageMagick-${PV}.tar.xz

cd "ImageMagick-${PV}"

patch -p1 <"$FILESDIR/ImageMagick-6.9.10-60-libs_only-1.patch"

cd "${T}"

doconf --sysconfdir=/etc --enable-hdri --with-modules --disable-static

make
make install DESTDIR="${D}"

finalize
