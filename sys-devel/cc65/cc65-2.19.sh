#!/bin/sh
source "../../common/init.sh"

get https://github.com/cc65/cc65/archive/refs/tags/V$PV.tar.gz "${P}.tar.gz"
acheck

cd "${S}"

make V=1
make install V=1 DESTDIR="${D}" PREFIX="/pkg/main/${PKG}.core.${PVRF}"

finalize
