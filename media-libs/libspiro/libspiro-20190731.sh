#!/bin/sh
source "../../common/init.sh"

get https://github.com/fontforge/libspiro/releases/download/${PV}/${P}.tar.gz
acheck

cd "${T}"

doconf --disable-static

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
