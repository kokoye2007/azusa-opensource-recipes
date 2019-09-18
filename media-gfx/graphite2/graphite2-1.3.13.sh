#!/bin/sh
source "../../common/init.sh"

get https://github.com/silnrsi/graphite/releases/download/${PV}/${P}.tgz

cd "${P}"

sed -i '/cmptest/d' tests/CMakeLists.txt

cd "${T}"

cmake -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR} "${CHPATH}/${P}"

make
make install DESTDIR="${D}"

finalize
