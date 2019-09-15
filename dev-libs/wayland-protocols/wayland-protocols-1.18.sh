#!/bin/sh
source "../../common/init.sh"

get https://wayland.freedesktop.org/releases/${P}.tar.xz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
