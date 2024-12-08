#!/bin/sh
source "../../common/init.sh"

get https://xcb.freedesktop.org/dist/${P}.tar.xz
acheck

cd "${T}"

doconf --localstatedir=/var

make
make install DESTDIR="${D}"

finalize
