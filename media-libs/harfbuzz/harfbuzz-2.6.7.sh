#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/harfbuzz/release/${P}.tar.xz
acheck

cd "${T}"

doconf --with-gobject --with-graphite2 --disable-static

make
make install DESTDIR="${D}"

finalize
