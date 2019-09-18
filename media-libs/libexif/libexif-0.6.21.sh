#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/libexif/${P}.tar.bz2

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
