#!/bin/sh
source "../../common/init.sh"

get https://github.com/libical/libical/releases/download/v${PV}/${P}.tar.gz

cd "${T}"

importpkg dev-libs/libxml2

cmake "${CHPATH}/${P}" -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR} -DCMAKE_BUILD_TYPE=Release \
	-DSHARED_ONLY=yes -DICAL_BUILD_DOCS=false -DGOBJECT_INTROSPECTION=true -DICAL_GLIB_VAPI=true

make
make install DESTDIR="${D}"

finalize
