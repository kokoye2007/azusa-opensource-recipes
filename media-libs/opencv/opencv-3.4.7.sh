#!/bin/sh
source "../../common/init.sh"

get https://github.com/opencv/${PN}/archive/${PV}.tar.gz

cd "${T}"

cmake "${CHPATH}/${P}" -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DOPENCV_GENERATE_PKGCONFIG=YES -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR}

make
make install DESTDIR="${D}"

finalize
