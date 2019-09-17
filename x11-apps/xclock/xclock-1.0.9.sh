#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/app/${P}.tar.bz2

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
