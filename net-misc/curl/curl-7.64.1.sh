#!/bin/sh
source "../../common/init.sh"

get https://curl.haxx.se/download/${P}.tar.xz

cd "${T}"

export CFLAGS="$(pkg-config --cflags libbrotlidec)"
export LIBS="$(pkg-config --libs libbrotlidec)"

doconf

make
make install DESTDIR="${D}"

finalize
