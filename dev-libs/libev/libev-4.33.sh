#!/bin/sh
source "../../common/init.sh"

get http://dist.schmorp.de/${PN}/${P}.tar.gz
acheck

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
