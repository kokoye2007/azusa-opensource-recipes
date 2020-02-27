#!/bin/sh
source "../../common/init.sh"

get http://isl.gforge.inria.fr/${P}.tar.xz
acheck

cd "${T}"

importpkg gmp

# configure & build
doconf 

make
make install DESTDIR="${D}"

finalize
