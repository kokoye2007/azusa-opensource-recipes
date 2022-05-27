#!/bin/sh
source "../../common/init.sh"

get https://github.com/hyperrealm/${PN}/archive/v${PV}.tar.gz
acheck

cd "${P}"

autoreconf

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
