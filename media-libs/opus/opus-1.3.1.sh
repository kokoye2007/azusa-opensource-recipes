#!/bin/sh
source "../../common/init.sh"

get https://archive.mozilla.org/pub/opus/${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
