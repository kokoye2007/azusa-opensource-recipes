#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/trousers/${PN}/${P}.tar.gz
acheck

importpkg openssl

aautoreconf

cd "${T}"

doconf --with-gui=openssl

make
make install DESTDIR="${D}"

finalize
