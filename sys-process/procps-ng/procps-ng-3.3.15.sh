#!/bin/sh
source "../../common/init.sh"

get https://sourceforge.net/projects/${PN}/files/Production/${P}.tar.xz

cd "${P}"

doconf --disable-static --disable-kill

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

finalize
