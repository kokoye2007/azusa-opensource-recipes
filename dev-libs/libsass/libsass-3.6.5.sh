#!/bin/sh
source "../../common/init.sh"

get https://github.com/sass/libsass/archive/"${PV}"/"${P}".tar.gz
acheck

cd "${P}" || exit

libtoolize -fi
autoreconf -fi

cd "${T}" || exit

doconf --disable-static --disable-tests --enable-shared

make
make install DESTDIR="${D}"

finalize
