#!/bin/sh
source "../../common/init.sh"

get http://caca.zoy.org/raw-attachment/wiki/${PN}/${P}.tar.gz
acheck

cd "${P}"

sed -i -e 's:-g -O2 -fno-strength-reduce -fomit-frame-pointer::' configure

cd "${T}"

importpkg zlib

doconf

make
make install DESTDIR="${D}"

finalize
