#!/bin/sh
source "../../common/init.sh"

get https://kohei.us/files/orcus/src/${P}.tar.xz
acheck

cd "${T}"

importpkg dev-libs/boost zlib

doconf --disable-werror --enable-python --enable-spreadsheet-model --disable-static --with-tools

make
make install DESTDIR="${D}"

finalize
