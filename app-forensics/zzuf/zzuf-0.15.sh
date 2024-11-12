#!/bin/sh
source "../../common/init.sh"

get https://github.com/samhocevar/zzuf/releases/download/v"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
