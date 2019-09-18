#!/bin/sh
source "../../common/init.sh"

get https://xkbcommon.org/download/${P}.tar.xz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
