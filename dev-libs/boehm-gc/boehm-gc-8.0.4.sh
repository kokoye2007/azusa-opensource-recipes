#!/bin/sh
source "../../common/init.sh"

get https://github.com/ivmai/bdwgc/releases/download/v"${PV}"/gc-"${PV}".tar.gz
acheck

cd "${T}" || exit

importpkg dev-libs/libatomic_ops

doconf --with-libatomic-ops --enable-cplusplus --enable-mmap

make
make install DESTDIR="${D}"

finalize
