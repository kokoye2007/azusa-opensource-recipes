#!/bin/sh
source "../../common/init.sh"

get https://github.com/${PN}/${PN}/releases/download/${PV}/${P}.tar.xz
acheck

cd "${T}"

importpkg zlib

docmake -DWITH_NATUS=OFF -DWITH_PYTHON2=OFF -DWITH_VALA=ON -DWITH_WEBKIT=OFF -DWITH_PERL=OFF -DWITH_PYTHON3=OFF
# -DFORCE_SYSTEM_LIBMODMAN=ON

finalize
