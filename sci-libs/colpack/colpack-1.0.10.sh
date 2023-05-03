#!/bin/sh
source "../../common/init.sh"

get https://github.com/CSCsw/ColPack/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${S}"

aautoreconf

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
