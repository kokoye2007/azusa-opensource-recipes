#!/bin/sh
source "../../common/init.sh"

MY_PN="${PN/xorg-/xorg}"
MY_P="${MY_PN}-${PV}"
get https://xorg.freedesktop.org/archive/individual/proto/"${MY_P}".tar.xz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
