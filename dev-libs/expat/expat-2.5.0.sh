#!/bin/sh
source "../../common/init.sh"

get https://github.com/libexpat/libexpat/releases/download/R_${PV//./_}/${P}.tar.bz2
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
