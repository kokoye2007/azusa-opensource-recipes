#!/bin/sh
source "../../common/init.sh"

get https://github.com/uclouvain/${PN}/archive/v${PV}/${P}.tar.gz
acheck

cd "${T}"

docmake -DBUILD_STATIC_LIBS=OFF

make
make install DESTDIR="${D}"

finalize
