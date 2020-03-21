#!/bin/sh
source "../../common/init.sh"

MY_P=SDL2_net-${PV}
get http://www.libsdl.org/projects/SDL_net/release/${MY_P}.tar.gz
acheck

cd "${T}"

doconf --disable-gui --disable-static

make
make install DESTDIR="${D}"

finalize
