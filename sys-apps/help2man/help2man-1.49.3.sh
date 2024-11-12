#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/"${PN}"/"${P}".tar.xz
acheck

cd "${T}" || exit

doconf --enable-nls

make
make install DESTDIR="${D}"

finalize
