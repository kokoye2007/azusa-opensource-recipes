#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/gnu/grep/${P}.tar.xz
acheck

cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
