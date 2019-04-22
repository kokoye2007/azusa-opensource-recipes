#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/gnu/tar/${P}.tar.bz2

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
