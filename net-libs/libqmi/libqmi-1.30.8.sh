#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/libqmi/${P}.tar.xz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
