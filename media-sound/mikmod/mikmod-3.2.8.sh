#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/${PN}/${P}.tar.gz
acheck

cd "${T}"

importpkg ncurses

doconf

make
make install DESTDIR="${D}"

finalize
