#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/snappy/archive/${PV}.tar.gz

cd "${T}"

cmake -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR} "${CHPATH}/${P}"

cmake --build .
make install DESTDIR="${D}"

finalize
