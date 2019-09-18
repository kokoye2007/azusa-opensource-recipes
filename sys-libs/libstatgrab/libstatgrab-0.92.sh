#!/bin/sh
source "../../common/init.sh"

get http://www.mirrorservice.org/sites/ftp.i-scream.org/pub/i-scream/libstatgrab/${P}.tar.gz

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
