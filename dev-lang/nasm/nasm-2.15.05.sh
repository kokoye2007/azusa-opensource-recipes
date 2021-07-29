#!/bin/sh
source "../../common/init.sh"

get https://www.nasm.us/pub/nasm/releasebuilds/${PV}/${P}.tar.bz2
acheck

cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
