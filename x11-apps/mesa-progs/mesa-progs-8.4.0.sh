#!/bin/sh
source "../../common/init.sh"

MY_PN="${PN/progs/demos}"
MY_P="${MY_PN}-${PV}"

get https://mesa.freedesktop.org/archive/demos/"${MY_P}".tar.bz2
acheck

cd "${T}" || exit

importpkg media-libs/glu media-libs/freeglut

doconf

make
make install DESTDIR="${D}"

finalize
