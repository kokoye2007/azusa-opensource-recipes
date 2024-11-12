#!/bin/sh
source "../../common/init.sh"

get https://github.com/dbry/WavPack/releases/download/"${PV}"/"${P}".tar.xz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
