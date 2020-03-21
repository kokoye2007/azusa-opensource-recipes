#!/bin/sh
source "../../common/init.sh"

get http://www.exiv2.org/builds/${P}-Source.tar.gz

cd "${T}"

cmake -DCMAKE_INSTALL_PREFIX="/pkg/main/${PKG}.core.${PVRF}" -DCMAKE_BUILD_TYPE=Release -DEXIV2_ENABLE_VIDEO=yes -DEXIV2_ENABLE_WEBREADY=yes -DEXIV2_ENABLE_CURL=yes -DEXIV2_BUILD_SAMPLES=no -G "Unix Makefiles" "${CHPATH}/${P}-Source"

make
make install DESTDIR="${D}"

finalize
