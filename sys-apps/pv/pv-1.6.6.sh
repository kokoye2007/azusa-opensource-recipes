#!/bin/sh
source "../../common/init.sh"

get https://www.ivarch.com/programs/sources/${P}.tar.bz2
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
