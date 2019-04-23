#!/bin/sh
source "../../common/init.sh"

get https://sourceforge.net/projects/${PN}/files/Production/${P}.tar.xz

cd "${P}"

doconf --disable-static --disable-kill

make
make install DESTDIR="${D}"

finalize
