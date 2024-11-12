#!/bin/sh
source "../../common/init.sh"

MY_P="${P/sdl-/SDL_}"
MY_COMMIT="5d792dde2f764daf15dc48521774a3354330db69"
get https://github.com/libsdl-org/SDL_image/archive/${MY_COMMIT}.tar.gz "${MY_P}.tar.gz"
acheck

importpkg X media-libs/libjpeg-turbo media-libs/tiff

cd "${T}" || exit

doconf --disable-static --disable-jpg-shared --disable-png-shared --disable-tif-shared --disable-webp-shared --enable-gif --enable-jpg --enable-tif --enable-png --enable-webp --enable-bmp --enable-lbm --enable-pcx --enable-pnm --enable-tga --enable-xcf --enable-xpm --enable-xv

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
