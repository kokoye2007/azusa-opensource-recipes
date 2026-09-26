#!/bin/sh
source "../../common/init.sh"

get  https://github.com/c-ares/c-ares/releases/download/v${PV}/${P}.tar.gz
acheck

cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
