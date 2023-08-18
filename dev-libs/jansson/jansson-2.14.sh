#!/bin/sh
source "../../common/init.sh"

get http://www.digip.org/jansson/releases/${P}.tar.gz

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
