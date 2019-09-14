#!/bin/sh
source "../../common/init.sh"

get https://github.com/uriparser/uriparser/releases/download/${P}/${P}.tar.bz2

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
