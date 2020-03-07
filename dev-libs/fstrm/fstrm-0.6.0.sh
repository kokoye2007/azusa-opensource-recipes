#!/bin/sh
source "../../common/init.sh"

get https://dl.farsightsecurity.com/dist/${PN}/${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
