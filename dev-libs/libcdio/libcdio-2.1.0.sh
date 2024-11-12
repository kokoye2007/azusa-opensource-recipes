#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/"${PN}"/"${P}".tar.bz2
acheck

cd "${T}" || exit

importpkg ncurses

doconf

make
make install DESTDIR="${D}"

finalize
