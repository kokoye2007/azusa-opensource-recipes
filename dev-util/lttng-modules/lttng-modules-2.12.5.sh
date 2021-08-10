#!/bin/sh
source "../../common/init.sh"

get https://lttng.org/files/${PN}/${P}.tar.bz2
acheck

cd "${T}"

doconf --disable-man-pages

make V=1
make install DESTDIR="${D}"

finalize
