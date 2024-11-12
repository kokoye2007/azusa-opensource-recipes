#!/bin/sh
source "../../common/init.sh"

get https://github.com/ivmai/libatomic_ops/releases/download/v"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf --enable-shared --disable-static

make
make install DESTDIR="${D}"

finalize
