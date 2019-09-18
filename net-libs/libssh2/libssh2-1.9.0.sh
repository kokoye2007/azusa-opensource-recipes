#!/bin/sh
source "../../common/init.sh"

get https://www.libssh2.org/download/${P}.tar.gz

cd "${T}"

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
