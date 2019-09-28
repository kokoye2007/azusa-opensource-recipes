#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/${PN}/rel${PV}/${P}.tar.xz
acheck

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
