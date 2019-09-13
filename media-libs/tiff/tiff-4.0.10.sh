#!/bin/sh
source "../../common/init.sh"

get https://download.osgeo.org/libtiff/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
