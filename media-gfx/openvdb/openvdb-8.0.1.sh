#!/bin/sh
source "../../common/init.sh"

get https://github.com/AcademySoftwareFoundation/${PN}/archive/v${PV}.tar.gz
acheck

cd "${T}"

importpkg media-libs/ilmbase dev-libs/log4cplus dev-libs/c-blosc zlib dev-libs/boost media-libs/mesa media-libs/glu

CMAKEOPTS=(
	-DCHOST="${CHOST}"
	-DOPENVDB_ABI_VERSION_NUMBER="7"
	-DOPENVDB_BUILD_DOCS=ON
	-DOPENVDB_BUILD_UNITTESTS=OFF
	-DOPENVDB_BUILD_VDB_LOD=ON
	-DOPENVDB_BUILD_VDB_RENDER=ON
	-DOPENVDB_BUILD_VDB_VIEW=ON
	-DOPENVDB_CORE_SHARED=ON
	-DOPENVDB_CORE_STATIC=ON
	-DOPENVDB_ENABLE_RPATH=OFF
	-DUSE_CCACHE=OFF
	-DUSE_COLORED_OUTPUT=ON
	-DUSE_EXR=ON
	-DUSE_LOG4CPLUS=ON
)

docmake "${CMAKEOPTS[@]}"

finalize
