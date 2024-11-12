#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/mpfr/"${P}".tar.xz

cd "${T}" || exit

# configure & build
doconf --disable-static --enable-thread-safe

make
make install DESTDIR="${D}"

finalize
