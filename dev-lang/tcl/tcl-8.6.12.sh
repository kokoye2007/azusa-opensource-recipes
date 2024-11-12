#!/bin/sh
source "../../common/init.sh"
inherit libs

get https://download.sourceforge.net/tcl/"${PN}"-core"${PV}"-src.tar.gz
acheck

preplib

cd "${S}/unix" || exit

doconflight --enable-threads --enable-shared --enable-64bit

make
make install DESTDIR="${D}"

finalize
