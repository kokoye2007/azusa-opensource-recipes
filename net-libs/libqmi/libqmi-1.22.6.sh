#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/libqmi/${P}.tar.xz

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
