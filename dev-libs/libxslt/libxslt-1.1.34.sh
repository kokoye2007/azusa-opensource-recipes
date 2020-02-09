#!/bin/sh
source "../../common/init.sh"

get ftp://xmlsoft.org/libxml2/${P}.tar.gz
acheck

cd "${T}"

importpkg python-2.7 icu-uc

doconf

make
make install DESTDIR="${D}"

finalize
