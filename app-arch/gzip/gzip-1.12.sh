#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.xz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
