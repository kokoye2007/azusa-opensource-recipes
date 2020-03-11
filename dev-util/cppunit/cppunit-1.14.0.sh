#!/bin/sh
source "../../common/init.sh"

get https://dev-www.libreoffice.org/src/${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
