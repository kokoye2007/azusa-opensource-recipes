#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/gsl/"${P}".tar.gz

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
