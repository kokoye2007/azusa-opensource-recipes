#!/bin/sh
source "../../common/init.sh"

get https://github.com/projectatomic/${PN}/releases/download/v${PV}/${P}.tar.xz
acheck

cd "${S}"

aautoreconf

cd "${T}"

importpkg sys-libs/libcap sys-libs/libselinux dev-libs/libxslt

doconf

make
make install DESTDIR="${D}"

finalize
