#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/pub/gnu/"${PN}"/"${P}".tar.xz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
