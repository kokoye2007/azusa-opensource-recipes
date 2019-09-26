#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/${PN}/archive/v${PV}.tar.gz

cd "${T}"

cmake "${CHPATH}/${P}" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR}

make
make install DESTDIR="${D}"

finalize
