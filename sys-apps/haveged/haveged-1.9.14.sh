#!/bin/sh
source "../../common/init.sh"

get https://github.com/jirka-h/${PN}/archive/v${PV}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
