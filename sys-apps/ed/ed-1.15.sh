#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/gnu/${PN}/${P}.tar.lz

cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
