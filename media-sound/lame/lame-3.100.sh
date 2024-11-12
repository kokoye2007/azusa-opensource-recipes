#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/"${PN}"/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg ncurses
export LIBS="$(pkg-config --libs ncurses)"

doconf --disable-static --enable-nasm

make
make install DESTDIR="${D}"

finalize
