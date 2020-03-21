#!/bin/sh
source "../../common/init.sh"

#get https://dev.gentoo.org/~hwoarang/distfiles/${P}.tar.gz
get http://distfiles.gentoo.org/distfiles/${P}.tar.gz

make
make install prefix="${D}/pkg/main/${PKG}.core.${PVRF}"

finalize
