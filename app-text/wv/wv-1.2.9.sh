#!/bin/sh
source "../../common/init.sh"

get http://www.abisource.com/downloads/wv/${PV}/${P}.tar.gz

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
