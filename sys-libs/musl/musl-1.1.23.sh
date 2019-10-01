#!/bin/sh
source "../../common/init.sh"

get https://www.musl-libc.org/releases/${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
