#!/bin/sh
source "../../common/init.sh"

get https://libbsd.freedesktop.org/releases/${P}.tar.xz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
