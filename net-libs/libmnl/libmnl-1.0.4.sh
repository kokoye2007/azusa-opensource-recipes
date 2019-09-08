#!/bin/sh
source "../../common/init.sh"

get https://netfilter.org/projects/libmnl/files/${P}.tar.bz2

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
