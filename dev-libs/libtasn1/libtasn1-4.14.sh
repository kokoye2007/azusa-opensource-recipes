#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/libtasn1/${P}.tar.gz

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
