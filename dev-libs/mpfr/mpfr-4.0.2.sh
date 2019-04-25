#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/${PN}/${P}.tar.xz

cd "${T}"

# configure & build
doconf --disable-static --enable-thread-safe

make
make install DESTDIR="${D}"

finalize
