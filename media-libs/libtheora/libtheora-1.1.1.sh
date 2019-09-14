#!/bin/sh
source "../../common/init.sh"

get http://downloads.xiph.org/releases/theora/${P}.tar.bz2

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
