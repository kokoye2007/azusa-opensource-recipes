#!/bin/sh
source "../../common/init.sh"

get https://github.com/ccache/ccache/releases/download/v${PV}/${P}.tar.xz
acheck

cd "${T}"

importpkg zlib

doconf

make
make install DESTDIR="${D}"

finalize
