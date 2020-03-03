#!/bin/sh
source "../../common/init.sh"

get https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz
acheck

cd "${T}"

docmake

make
make install DESTDIR="${D}"

finalize
