#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/${PN}/${P}.tar.bz2
acheck

cd "${T}"

importpkg ncurses

doconf

make
make install DESTDIR="${D}"

finalize
