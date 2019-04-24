#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/libidn/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
