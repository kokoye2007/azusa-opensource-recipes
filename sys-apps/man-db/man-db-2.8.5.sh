#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.nongnu.org/releases/man-db/${P}.tar.xz

cd ${T}

# configure & build
${CHPATH}/${P}/configure --prefix=/pkg/main/${PKG}.core.${PVR}

make
make install DESTDIR="${D}"

