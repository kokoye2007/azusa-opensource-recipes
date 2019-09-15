#!/bin/sh
source "../../common/init.sh"

get https://dri.freedesktop.org/libdrm/${P}.tar.bz2

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
