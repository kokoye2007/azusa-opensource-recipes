#!/bin/sh
source "../../common/init.sh"

get http://david.freetype.org/jam/${P}.tar.bz2
acheck

cd "${P}"

apatch "$FILESDIR/ftjam-2.5.3"*

export CC=gcc

doconf

make
make install DESTDIR="${D}"

finalize
