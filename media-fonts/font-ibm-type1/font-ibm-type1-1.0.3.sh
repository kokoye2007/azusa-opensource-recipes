#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/font/${P}.tar.bz2
acheck
prepare

cd "${T}"

doconf --localstatedir=/var

make
make install DESTDIR="${D}"

finalize
