#!/bin/sh
source "../../common/init.sh"

get https://download.mono-project.com/sources/${PN}/${P}.tar.gz
acheck

cd "${T}"

importpkg media-libs/tiff libjpeg media-libs/giflib x11-libs/cairo

doconf --with-pango

make
make install DESTDIR="${D}"

finalize
