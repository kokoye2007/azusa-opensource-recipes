#!/bin/sh
source "../../common/init.sh"

get https://github.com/${PN}/${PN}3/archive/${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
