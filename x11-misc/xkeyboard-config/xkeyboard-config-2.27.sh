#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/data/${PN}/${P}.tar.bz2

cd "${T}"

doconf --localstatedir=/var --with-xkb-rules-symlink=xorg

make install DESTDIR="${D}"

finalize
