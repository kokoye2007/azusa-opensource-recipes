#!/bin/sh
source "../../common/init.sh"

get https://www.cairographics.org/releases/${P}.tar.xz

cd "${T}"

doconf --disable-static --enable-tee

make
make install DESTDIR="${D}"

finalize
