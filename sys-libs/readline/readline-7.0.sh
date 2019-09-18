#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/readline/${P}.tar.gz

cd "${T}"

# configure & build
doconf --disable-static

make
make install DESTDIR="${D}"

finalize
