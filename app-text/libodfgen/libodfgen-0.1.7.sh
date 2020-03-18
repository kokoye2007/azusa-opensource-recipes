#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/libwpd/${P}.tar.xz
acheck

cd "${T}"

doconf --disable-static --with-docs

make
make install DESTDIR="${D}"

finalize
