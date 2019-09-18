#!/bin/sh
source "../../common/init.sh"

get https://www.imagemagick.org/download/releases/ImageMagick-${PV}.tar.xz

cd "${T}"

doconf --sysconfdir=/etc --enable-hdri --with-modules --with-perl --disable-static

make
make install DESTDIR="${D}"

finalize
