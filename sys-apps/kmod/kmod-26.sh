#!/bin/sh
source "../../common/init.sh"

get https://mirrors.edge.kernel.org/pub/linux/utils/kernel/kmod/${P}.tar.xz

cd "${T}"

doconf --with-xz --with-zlib

make
make install DESTDIR="${D}"

finalize
