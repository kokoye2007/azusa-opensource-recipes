#!/bin/sh
source "../../common/init.sh"

get https://sourceforge.net/projects/giflib/files/${P}.tar.gz

cd "${P}"

make
make install PREFIX="${D}/pkg/main/${PKG}.core.${PVR}"

finalize
