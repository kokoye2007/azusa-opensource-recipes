#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/ModemManager/ModemManager-"${PV}".tar.xz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
