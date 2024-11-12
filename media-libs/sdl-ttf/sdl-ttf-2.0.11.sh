#!/bin/sh
source "../../common/init.sh"

MY_P="${P/sdl-/SDL_}"
get http://www.libsdl.org/projects/SDL_ttf/release/"${MY_P}".tar.gz
acheck

importpkg X media-libs/libjpeg-turbo media-libs/tiff

cd "${T}" || exit

doconf --disable-static --with-X

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
