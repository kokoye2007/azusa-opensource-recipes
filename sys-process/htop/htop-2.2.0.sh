#!/bin/sh
source "../../common/init.sh"

get https://hisham.hm/htop/releases/${PV}/${P}.tar.gz
acheck

cd "${T}"

importpkg sys-libs/ncurses

doconf --disable-hwloc --enable-taskstats --enable-cgroup --enable-linux-affinity --enable-unicode

make
make install DESTDIR="${D}"

finalize
