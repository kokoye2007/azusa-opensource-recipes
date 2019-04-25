#!/bin/sh
source "../../common/init.sh"

get https://carlowood.github.io/which/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
