#!/bin/sh
source "../../common/init.sh"

get https://pkg-config.freedesktop.org/releases/${P}.tar.gz

cd "${T}"

# configure & build
doconf --enable-languages=c,c++ --disable-bootstrap --disable-libmpx --with-system-zlib

make
make install DESTDIR="${D}"

finalize
