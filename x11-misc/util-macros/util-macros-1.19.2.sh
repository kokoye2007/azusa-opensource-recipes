#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/util/${P}.tar.bz2

cd "${T}"

doconf --localstatedir=/var --disable-static

make install DESTDIR="${D}"

finalize
