#!/bin/sh
source "../../common/init.sh"

get https://github.com/sass/libsass/archive/${PV}/${P}.tar.gz
acheck

cd "${P}"

libtoolize -fi
autoreconf -fi

cd "${T}"

doconf --disable-static --disable-tests --enable-shared

make
make install DESTDIR="${D}"

finalize
