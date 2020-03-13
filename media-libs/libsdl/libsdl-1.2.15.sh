#!/bin/sh
source "../../common/init.sh"

get http://www.libsdl.org/release/SDL-${PV}.tar.gz
acheck

cd "SDL-${PV}"

sed -e '/_XData32/s:register long:register _Xconst long:' -i src/video/x11/SDL_x11sym.h

importpkg X

doconf --disable-static

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
