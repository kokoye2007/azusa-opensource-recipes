#!/bin/sh
source "../../common/init.sh"

get https://gitlab.freedesktop.org/spice/${PN}/-/archive/${P}/${PN}-${P}.tar.bz2
acheck

cd "${S}"

aautoreconf

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
