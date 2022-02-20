#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.xz
acheck

cd "${T}"

doconf CFLAGS="-std=gnu99 -pipe -O2"

make
make install DESTDIR="${D}"

finalize
