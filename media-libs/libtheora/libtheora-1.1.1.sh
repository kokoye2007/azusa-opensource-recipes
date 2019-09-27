#!/bin/sh
source "../../common/init.sh"

get http://downloads.xiph.org/releases/theora/${P}.tar.bz2

cd "${T}"

doconf --disable-static --disable-oggtest --disable-vorbistest --disable-sdltest --disable-examples

make
make install DESTDIR="${D}"

finalize
