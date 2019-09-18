#!/bin/sh
source "../../common/init.sh"

get https://github.com/libarchive/libarchive/releases/download/v${PV}/${P}.tar.gz

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
