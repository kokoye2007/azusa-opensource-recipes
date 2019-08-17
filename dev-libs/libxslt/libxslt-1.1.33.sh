#!/bin/sh
source "../../common/init.sh"

get ftp://xmlsoft.org/libxml2/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
