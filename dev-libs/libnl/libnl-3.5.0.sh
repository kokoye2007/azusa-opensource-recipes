#!/bin/sh
source "../../common/init.sh"

get https://github.com/thom311/libnl/releases/download/libnl3_5_0/${P}.tar.gz
acheck

cd "${T}"

doconf --disable-static --enable-cli=sbin

make
make install DESTDIR="${D}"

finalize
