#!/bin/sh
source "../../common/init.sh"

get https://github.com/williamh/dotconf/archive/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${S}" || exit

aautoreconf

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
