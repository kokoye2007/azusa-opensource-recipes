#!/bin/sh
source "../../common/init.sh"

get http://anduin.linuxfromscratch.org/BLFS/iso-codes/"${P}".tar.xz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
