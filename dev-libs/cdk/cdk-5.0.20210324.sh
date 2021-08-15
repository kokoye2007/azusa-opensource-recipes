#!/bin/sh
source "../../common/init.sh"

MY_PV="${PV//./-}"
MY_PV="${MY_PV/-/.}"

get ftp://ftp.invisible-island.net/cdk/${PN}-${MY_PV}.tgz
acheck

importpkg sys-libs/ncurses

cd "${T}"

doconflight --disable-rpath-hack --with-shared --with-pkg-config --with-ncursesw

make
make install DESTDIR="${D}"

finalize
