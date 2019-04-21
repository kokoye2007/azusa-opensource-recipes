#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/gnu/${PN}/${P}.tar.xz

cd "${T}"

doconf --disable-static

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

finalize
