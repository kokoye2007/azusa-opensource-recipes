#!/bin/sh
source "../../common/init.sh"

get https://linuxcontainers.org/downloads/lxc/${P}.tar.gz
acheck

cd "${P}"

doconf

make
make install DESTDIR="${D}"

finalize
