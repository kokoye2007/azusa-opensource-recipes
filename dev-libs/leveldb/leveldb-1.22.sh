#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/leveldb/archive/${PV}.tar.gz

cd "${T}"

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR} "${CHPATH}/${P}"

cmake --build .
make install DESTDIR="${D}"

finalize
