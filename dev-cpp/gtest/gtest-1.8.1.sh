#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/googletest/archive/release-${PV}.tar.gz

cd "${T}"

cmake -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR} "${CHPATH}/googletest-release-${PV}"

make
make install DESTDIR="${D}"

finalize
