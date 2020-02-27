#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.gz
acheck

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
