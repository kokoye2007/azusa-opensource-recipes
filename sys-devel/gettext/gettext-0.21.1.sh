#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
