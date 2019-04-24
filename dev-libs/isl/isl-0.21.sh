#!/bin/sh
source "../../common/init.sh"

get http://isl.gforge.inria.fr/${P}.tar.xz

cd "${T}"

# configure & build
doconf 

make
make install DESTDIR="${D}"

finalize
