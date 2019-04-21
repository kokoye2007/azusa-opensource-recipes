#!/bin/sh
source "../../common/init.sh"

get ftp://sourceware.org/pub/elfutils/${PV}/${P}.tar.bz2

cd "${T}"

doconf

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

finalize
