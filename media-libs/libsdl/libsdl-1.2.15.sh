#!/bin/sh
source "../../common/init.sh"

get http://www.libsdl.org/release/SDL-${PV}.tar.gz

cd "SDL-${PV}"

sed -e '/_XData32/s:register long:register _Xconst long:' -i src/video/x11/SDL_x11sym.h

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
