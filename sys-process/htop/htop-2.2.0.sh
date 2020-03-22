#!/bin/sh
source "../../common/init.sh"

get https://hisham.hm/htop/releases/${PV}/${P}.tar.gz
acheck

cd "${S}"

rm -v missing

cd "${T}"

importpkg sys-libs/ncurses

export CPPFLAGS="${CPPFLAGS} -DMAJOR_IN_SYSMACROS"

doconf --disable-hwloc --enable-taskstats --enable-cgroup --enable-linux-affinity --enable-unicode

make
make install DESTDIR="${D}"

finalize
