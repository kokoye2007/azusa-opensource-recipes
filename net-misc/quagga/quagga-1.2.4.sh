#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.gnu.org/releases/quagga/${P}.tar.gz
acheck

cd "${T}"

importpkg readline
# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
