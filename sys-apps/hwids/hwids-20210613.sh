#!/bin/sh
source "../../common/init.sh"

get https://github.com/gentoo/hwids/archive/${P}.tar.gz
acheck

cd "${T}"

importpkg zlib

doconf

make
make install DESTDIR="${D}"

finalize
