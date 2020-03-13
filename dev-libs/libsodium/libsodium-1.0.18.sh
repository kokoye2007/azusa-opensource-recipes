#!/bin/sh
source "../../common/init.sh"

get https://github.com/jedisct1/${PN}/releases/download/${PV}-RELEASE/${P}.tar.gz
acheck

cd "${T}"

doconf --disable-static

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
