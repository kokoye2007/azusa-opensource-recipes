#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/libidn/${P}.tar.gz
acheck

cd "${T}"

importpkg dev-libs/libunistring

doconf

make
make install DESTDIR="${D}"

finalize
