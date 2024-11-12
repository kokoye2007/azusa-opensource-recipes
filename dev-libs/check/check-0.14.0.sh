#!/bin/sh
source "../../common/init.sh"

get https://github.com/libcheck/check/releases/download/"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf --disable-subunit

make
make install DESTDIR="${D}"

finalize
