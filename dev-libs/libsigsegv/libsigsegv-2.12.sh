#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/libsigsegv/${P}.tar.gz

cd "${T}"

doconf --enable-shared --disable-static

make
make install DESTDIR="${D}"

finalize
