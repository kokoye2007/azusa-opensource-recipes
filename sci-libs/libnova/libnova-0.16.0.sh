#!/bin/sh
source "../../common/init.sh"

fetchgit https://git.code.sf.net/p/libnova/libnova v0.16
acheck

cd "${S}" || exit

aautoreconf

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
