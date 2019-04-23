#!/bin/sh
source "../../common/init.sh"

get https://github.com/shadow-maint/shadow/releases/download/${PV}/${P}.tar.xz

cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
