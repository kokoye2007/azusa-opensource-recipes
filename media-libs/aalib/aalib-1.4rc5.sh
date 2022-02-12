#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/aa-project/${P}.tar.gz
acheck

apatch "$FILESDIR/aalib-1.4_rc4-m4.patch"

cd "${T}"

doconflight --disable-static --with-ncurses=/pkg/main/sys-libs.ncurses.dev --with-gpm-mouse=/pkg/main/sys-libs.gpm.dev

make
make install DESTDIR="${D}"

finalize
