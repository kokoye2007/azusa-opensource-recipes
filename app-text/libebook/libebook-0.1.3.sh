#!/bin/sh
source "../../common/init.sh"

MY_PN="libe-book"
MY_P="${MY_PN}-${PV}"
get https://download.sourceforge.net/${PN}/${MY_P}.tar.bz2
acheck

cd "${T}"

importpkg dev-libs/boost app-text/liblangtag

doconf --disable-static --disable-werror --with-tools --with-docs

make
make install DESTDIR="${D}"

finalize
