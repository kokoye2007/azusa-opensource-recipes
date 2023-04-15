#!/bin/sh
source "../../common/init.sh"

get https://github.com/jemalloc/jemalloc/releases/download/${PV}/${P}.tar.bz2
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
