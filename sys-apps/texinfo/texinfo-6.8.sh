#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnu.org/gnu/"${PN}"/"${P}".tar.xz

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
