#!/bin/sh
source "../../common/init.sh"

get https://github.com/thkukuk/rpcsvc-proto/releases/download/v"${PV}"/"${P}".tar.xz

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
