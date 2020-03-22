#!/bin/sh
source "../../common/init.sh"

get http://0pointer.de/lennart/projects/libdaemon/${P}.tar.gz

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
