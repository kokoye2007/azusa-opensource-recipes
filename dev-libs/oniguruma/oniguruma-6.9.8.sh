#!/bin/sh
source "../../common/init.sh"

get https://github.com/kkos/oniguruma/releases/download/v"${PV}"/onig-"${PV}".tar.gz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
