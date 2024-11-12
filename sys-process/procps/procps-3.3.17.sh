#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/"${PN}"-ng/"${PN}"-ng-"${PV}".tar.xz
acheck

cd "${T}" || exit

importpkg ncurses

doconf

make
make install DESTDIR="${D}"

finalize
