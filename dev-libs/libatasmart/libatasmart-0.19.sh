#!/bin/sh
source "../../common/init.sh"

get http://0pointer.de/public/${P}.tar.xz

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
