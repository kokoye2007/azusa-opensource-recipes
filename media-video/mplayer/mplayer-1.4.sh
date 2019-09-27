#!/bin/sh
source "../../common/init.sh"

get http://www.mplayerhq.hu/MPlayer/releases/MPlayer-${PV}.tar.xz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
