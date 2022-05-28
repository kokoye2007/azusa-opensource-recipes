#!/bin/sh
source "../../common/init.sh"

get https://github.com/skvadrik/re2c/releases/download/${PV}/${P}.tar.xz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
