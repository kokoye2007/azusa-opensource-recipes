#!/bin/sh
source "../../common/init.sh"

get https://nice.freedesktop.org/releases/${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
