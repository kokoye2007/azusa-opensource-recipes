#!/bin/sh
source "../../common/init.sh"

get https://www.cairographics.org/releases/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
