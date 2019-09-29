#!/bin/sh
source "../../common/init.sh"

get https://get.videolan.org/libdvdcss/${PV}/${P}.tar.bz2
acheck

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
