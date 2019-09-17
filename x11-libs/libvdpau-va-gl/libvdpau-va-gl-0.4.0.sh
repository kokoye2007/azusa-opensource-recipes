#!/bin/sh
source "../../common/init.sh"

get https://github.com/i-rinat/libvdpau-va-gl/archive/v${PV}/${P}.tar.gz

cd "${T}"

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR} "${CHPATH}/${P}"

make
make install DESTDIR="${D}"

finalize
