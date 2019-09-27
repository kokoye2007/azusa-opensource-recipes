#!/bin/sh
source "../../common/init.sh"

get https://tukaani.org/xz/${P}.tar.bz2

echo "Compiling ${P} ..."
cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize

