#!/bin/sh
source "../../common/init.sh"

MY_PN="CUnit"
MY_PV="${PV}-3"
MY_P="${MY_PN}-${MY_PV}"
get https://download.sourceforge.net/${PN}/${MY_P}.tar.bz2
acheck

cd "${S}"

aautoreconf

doconf --enable-curses

make
make install DESTDIR="${D}"

finalize
