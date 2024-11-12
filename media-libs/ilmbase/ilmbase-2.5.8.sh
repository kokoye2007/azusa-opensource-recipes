#!/bin/sh
source "../../common/init.sh"

get https://github.com/AcademySoftwareFoundation/openexr/archive/v"${PV}".tar.gz
acheck

cd "${T}" || exit

importpkg zlib

CMAKEOPTS=(
	-DBUILD_TESTING=OFF
	-DILMBASE_BUILD_BOTH_STATIC_SHARED=ON
	-DILMBASE_ENABLE_LARGE_STACK=ON
	-DILMBASE_INSTALL_PKG_CONFIG=ON
)

docmake "${CMAKEOPTS[@]}"

# fix the pkgconfig files
sed -i -e 's#libdir=${exec_prefix}//#libdir=/#' "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/pkgconfig"/*.pc

finalize
