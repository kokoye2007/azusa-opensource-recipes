#!/bin/sh
source "../../common/init.sh"

get https://github.com/projectatomic/${PN}/releases/download/v${PV}/${P}.tar.xz
acheck

cd "${T}"

importpkg sys-libs/libcap

doconf

make
make install DESTDIR="${D}"

finalize
