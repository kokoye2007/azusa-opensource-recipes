#!/bin/sh
source "../../common/init.sh"

get https://github.com/opencv/${PN}/archive/${PV}.tar.gz

cd "${T}"

cmake "${CHPATH}/${P}" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR}

make
make install DESTDIR="${D}"

finalize
