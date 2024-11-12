#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/libcdio/"${P}".tar.bz2
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
