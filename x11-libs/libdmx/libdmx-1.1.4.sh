#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/lib/${P}.tar.bz2

cd "${T}"

doconf --localstatedir=/var --disable-static

make
make install DESTDIR="${D}"

finalize
