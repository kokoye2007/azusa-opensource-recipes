#!/bin/sh
source "../../common/init.sh"

get https://github.com/maxmind/${PN}-api-c/archive/v${PV}.tar.gz
acheck

cd "${S}"
aautoreconf

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
