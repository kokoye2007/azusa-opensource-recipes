#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
