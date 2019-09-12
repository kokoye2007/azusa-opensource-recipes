#!/bin/sh
source "../../common/init.sh"

get https://strace.io/files/5.2/${P}.tar.xz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
