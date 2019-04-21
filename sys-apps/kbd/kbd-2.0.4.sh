#!/bin/sh
source "../../common/init.sh"

get https://mirrors.edge.kernel.org/pub/linux/utils/kbd/${P}.tar.xz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
