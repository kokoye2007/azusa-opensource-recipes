#!/bin/sh
source "../../common/init.sh"

get http://202.36.178.9/sage/${P}.tar.bz2
acheck

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
