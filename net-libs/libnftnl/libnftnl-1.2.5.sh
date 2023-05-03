#!/bin/sh
source "../../common/init.sh"

get https://netfilter.org/projects/${PN}/files/${P}.tar.xz
acheck

cd "${T}"

importpkg zlib

doconf

make
make install DESTDIR="${D}"

finalize
