#!/bin/sh
source "../../common/init.sh"

get http://bitmath.org/code/mtdev/${P}.tar.bz2
acheck
prepare

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
