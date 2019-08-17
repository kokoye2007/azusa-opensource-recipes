#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.gnu.org/releases/quagga/${P}.tar.gz

cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
