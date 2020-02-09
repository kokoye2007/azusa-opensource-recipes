#!/bin/sh
source "../../common/init.sh"

get https://sourceforge.net/projects/${PN}/files/Production/${P}.tar.xz
acheck

cd "${P}"

importpkg ncurses

doconf --disable-static --disable-kill

make
make install DESTDIR="${D}"

finalize
