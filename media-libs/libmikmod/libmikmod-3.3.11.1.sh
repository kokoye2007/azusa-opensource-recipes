#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/mikmod/${P}.tar.gz
acheck

cd "${T}"

doconf --enable-alsa --enable-nas --enable-pulseaudio --disable-sdl --enable-sdl2 --enable-openal --enable-oss --disable-osx --disable-debug --enable-threads --enable-static --disable-dl --enable-simd

make
make install DESTDIR="${D}"

finalize
