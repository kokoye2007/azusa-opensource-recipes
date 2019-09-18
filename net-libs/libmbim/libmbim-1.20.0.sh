#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/libmbim/${P}.tar.xz

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
