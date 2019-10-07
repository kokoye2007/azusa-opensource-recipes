#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/data/${P}.tar.bz2
acheck

cd "${T}"

doconf --disable-static

make install DESTDIR="${D}"

finalize
