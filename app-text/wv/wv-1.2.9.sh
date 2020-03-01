#!/bin/sh
source "../../common/init.sh"

get http://www.abisource.com/downloads/wv/${PV}/${P}.tar.gz
acheck

cd "${T}"

importpkg dev-libs/icu
export CFLAGS="-O2" # prefent wv from adding -ansi which will crash on icu headers

doconf --disable-static --with-libwmf

make
make install DESTDIR="${D}"

finalize
