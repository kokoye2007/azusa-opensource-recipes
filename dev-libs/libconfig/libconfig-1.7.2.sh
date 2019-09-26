#!/bin/sh
source "../../common/init.sh"

get https://github.com/hyperrealm/${PN}/archive/v${PV}.tar.gz

cd "${P}"

autoreconf

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
