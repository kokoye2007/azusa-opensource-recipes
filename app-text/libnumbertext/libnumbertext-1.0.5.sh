#!/bin/sh
source "../../common/init.sh"

get https://github.com/Numbertext/${PN}/releases/download/${PV}/${P}.tar.xz
acheck

cd "${T}"

doconf

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
