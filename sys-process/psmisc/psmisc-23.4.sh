#!/bin/sh
source "../../common/init.sh"

get https://sourceforge.net/projects/psmisc/files/psmisc/${P}.tar.xz
acheck

importpkg ncurses

cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
