#!/bin/sh
source "../../common/init.sh"

get https://gitlab.gnome.org/GNOME/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.bz2
acheck

cd "${S}"

aautoreconf

cd "${T}"

importpkg python-3.10 icu-uc

doconf

make
make install DESTDIR="${D}"

finalize
