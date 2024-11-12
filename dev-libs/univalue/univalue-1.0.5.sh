#!/bin/sh
source "../../common/init.sh"

get https://github.com/jgarzik/univalue/archive/v"${PV}".tar.gz
acheck

cd "${P}" || exit

libtoolize --install --force
autoreconf -fi

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
