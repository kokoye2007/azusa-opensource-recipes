#!/bin/sh
source "../../common/init.sh"

get https://releases.pagure.org/xmlto/${P}.tar.bz2

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
