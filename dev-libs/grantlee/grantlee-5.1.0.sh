#!/bin/sh
source "../../common/init.sh"

get http://downloads.grantlee.org/${P}.tar.gz

cd "${P}"

patch -p1 <"$FILESDIR/grantlee-5.1.0-upstream_fixes-2.patch"

cd "${T}"

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR} "${CHPATH}/${P}"

make
make install DESTDIR="${D}"

finalize
