#!/bin/sh
source "../../common/init.sh"

get https://wayland.freedesktop.org/releases/${P}.tar.xz
acheck

cd "${T}"

doconf --disable-documentation

make
make install DESTDIR="${D}"

finalize
