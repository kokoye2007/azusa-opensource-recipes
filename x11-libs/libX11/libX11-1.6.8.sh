#!/bin/sh
source "../../common/init.sh"

get https://xorg.freedesktop.org/archive/individual/lib/${P}.tar.bz2

cd "${T}"

doconf --enable-ipv6 --without-fop

make
make install DESTDIR="${D}"

finalize
