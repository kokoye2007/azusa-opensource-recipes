#!/bin/sh
source "../../common/init.sh"

get https://storage.googleapis.com/downloads.webmproject.org/releases/webp/${P}.tar.gz
acheck

cd "${T}"

importpkg media-libs/libsdl2 media-libs/libjpeg-turbo media-libs/tiff media-libs/giflib media-libs/freeglut

doconf --enable-everything

make
make install DESTDIR="${D}"

finalize
