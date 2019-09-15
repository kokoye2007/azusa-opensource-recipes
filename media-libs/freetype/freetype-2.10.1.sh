#!/bin/sh
source "../../common/init.sh"

get https://download.savannah.gnu.org/releases/freetype/${P}.tar.xz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
