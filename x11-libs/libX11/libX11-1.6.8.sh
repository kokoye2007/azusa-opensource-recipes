#!/bin/sh
source "../../common/init.sh"

get https://xorg.freedesktop.org/archive/individual/lib/${P}.tar.bz2

cd "${T}"

doconf --enable-ipv6 --without-fop --localstatedir=/var --disable-static

make
make install DESTDIR="${D}"

finalize
