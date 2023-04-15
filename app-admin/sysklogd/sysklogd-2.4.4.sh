#!/bin/sh
source "../../common/init.sh"

get https://github.com/troglobit/sysklogd/releases/download/v${PV}/${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
