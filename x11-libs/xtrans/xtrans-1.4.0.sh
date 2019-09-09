#!/bin/sh
source "../../common/init.sh"

get https://xorg.freedesktop.org/archive/individual/lib/${P}.tar.bz2

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
