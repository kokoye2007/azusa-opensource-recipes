#!/bin/sh
source "../../common/init.sh"

get https://libopenraw.freedesktop.org/download/${P}.tar.bz2

cd "${P}"

sed -i -r '/^\s?testadobesdk/d' exempi/tests/Makefile.am
autoreconf -fiv

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
