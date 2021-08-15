#!/bin/sh
source "../../common/init.sh"

get https://github.com/ueno/${PN}/releases/download/${PV}/${P}.tar.xz
acheck

cd "${T}"

doconf --enable-introspection --enable-nls --enable-static

make
make install DESTDIR="${D}"

finalize
