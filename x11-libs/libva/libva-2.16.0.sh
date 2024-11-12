#!/bin/sh
source "../../common/init.sh"

get https://github.com/intel/libva/releases/download/"${PV}"/"${P}".tar.bz2
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
