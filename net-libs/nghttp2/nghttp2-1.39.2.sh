#!/bin/sh
source "../../common/init.sh"

get https://github.com/nghttp2/nghttp2/releases/download/v${PV}/${P}.tar.bz2

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
