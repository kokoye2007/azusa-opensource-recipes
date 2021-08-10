#!/bin/sh
source "../../common/init.sh"

get https://github.com/libsdl-org/SDL_image/archive/refs/tags/release-${PV}.tar.gz
acheck

importpkg media-libs/libjpeg-turbo media-libs/tiff

cd "${T}"

doconf --disable-sdltest --enable-bmp --enable-gif --enable-jpg --disable-jpg-shared --enable-lbm --enable-pcx --enable-png --disable-png-shared --enable-pnm --enable-tga --enable-tif --disable-tif-shared --enable-xcf --enable-xpm --enable-xv --enable-webp --disable-webp-shared

make
make install DESTDIR="${D}"

finalize
