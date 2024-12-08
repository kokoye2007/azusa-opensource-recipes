#!/bin/sh
source "../../common/init.sh"

get https://xcb.freedesktop.org/dist/${P}.tar.xz
acheck

cd "${T}"

doconf

make install DESTDIR="${D}"

finalize
