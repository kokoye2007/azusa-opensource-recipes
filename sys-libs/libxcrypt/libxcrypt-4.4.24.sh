#!/bin/sh
source "../../common/init.sh"

get https://github.com/besser82/${PN}/archive/v${PV}.tar.gz
acheck

cd "${S}"

aautoreconf

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
