#!/bin/sh
source "../../common/init.sh"

get https://cmocka.org/files/${PV%.*}/${P}.tar.xz
acheck

cd "${T}"

docmake

make
make install DESTDIR="${D}"

finalize
