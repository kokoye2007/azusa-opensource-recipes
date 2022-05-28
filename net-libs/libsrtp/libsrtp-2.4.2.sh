#!/bin/sh
source "../../common/init.sh"

get https://github.com/cisco/${PN}/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
