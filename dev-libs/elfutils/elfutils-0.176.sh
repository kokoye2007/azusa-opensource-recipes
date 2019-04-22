#!/bin/sh
source "../../common/init.sh"

get ftp://sourceware.org/pub/elfutils/${PV}/${P}.tar.bz2

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
