#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/gnu/libtool/${P}.tar.gz

cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
