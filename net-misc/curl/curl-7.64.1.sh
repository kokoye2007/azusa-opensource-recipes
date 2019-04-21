#!/bin/sh
source "../../common/init.sh"

get https://curl.haxx.se/download/${P}.tar.xz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
