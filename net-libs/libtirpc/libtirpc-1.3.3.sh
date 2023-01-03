#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/libtirpc/${P}.tar.bz2
acheck

cd "${T}"

doconf --disable-static --disable-gssapi

make
make install DESTDIR="${D}"

finalize
