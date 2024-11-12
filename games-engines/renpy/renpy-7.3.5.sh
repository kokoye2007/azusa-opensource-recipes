#!/bin/sh
source "../../common/init.sh"

get https://www.renpy.org/dl/"${PV}"/"${P}"-source.tar.bz2
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
