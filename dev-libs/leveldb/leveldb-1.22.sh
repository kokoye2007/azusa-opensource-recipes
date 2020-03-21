#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/leveldb/archive/${PV}.tar.gz

cd "${T}"

cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVRF} "${CHPATH}/${P}"

cmake --build .
make install DESTDIR="${D}"

finalize
