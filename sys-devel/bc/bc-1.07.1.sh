#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/bc/${P}.tar.gz
acheck

cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
