#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/aa-project/${P}.tar.gz
acheck

cd "${T}"

doconflight --disable-static --with-ncurses=/pkg/main/sys-libs.ncurses.dev --with-gpm-mouse=/pkg/main/sys-libs.gpm.dev

make
make install DESTDIR="${D}"

finalize
