#!/bin/sh
source "../../common/init.sh"

get https://github.com/snapcore/snap-confine/releases/download/"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
