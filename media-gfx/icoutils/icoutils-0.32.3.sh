#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.nongnu.org/releases/${PN}/${P}.tar.bz2
acheck

importpkg libpng

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
