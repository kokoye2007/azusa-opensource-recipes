#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/libsigsegv/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf --enable-shared --disable-static

make
make install DESTDIR="${D}"

finalize
