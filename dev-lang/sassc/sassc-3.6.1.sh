#!/bin/sh
source "../../common/init.sh"

get https://github.com/sass/sassc/archive/${PV}/${P}.tar.gz
acheck

cd "${P}"

libtoolize -fi
autoreconf -fi

cd "${T}"

importpkg dev-libs/libsass

doconf

make
make install DESTDIR="${D}"

finalize
