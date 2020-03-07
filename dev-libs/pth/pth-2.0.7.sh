#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/pth/${P}.tar.gz
acheck

prepare

cd "${T}"

doconflight --disable-static

make
make install DESTDIR="${D}"

finalize
