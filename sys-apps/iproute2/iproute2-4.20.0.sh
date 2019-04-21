#!/bin/sh
source "../../common/init.sh"

get https://mirrors.edge.kernel.org/pub/linux/utils/net/iproute2/${P}.tar.xz

cd "${P}"

doconf

make
make install DESTDIR="${D}"

finalize
