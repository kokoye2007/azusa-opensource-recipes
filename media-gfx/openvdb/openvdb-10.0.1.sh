#!/bin/sh
source "../../common/init.sh"

get https://github.com/AcademySoftwareFoundation/"${PN}"/archive/v"${PV}".tar.gz "${P}.tar.gz"
acheck

cd "${T}" || exit

importpkg media-libs/openexr dev-libs/log4cplus dev-libs/c-blosc zlib dev-libs/boost media-libs/mesa media-libs/glu

CMAKEOPTS=(
	-DOPENVDB_ABI_VERSION_NUMBER="10"
	-DOPENVDB_BUILD_DOCS=ON
	-DOPENVDB_BUILD_UNITTESTS=OFF
	-DOPENVDB_BUILD_VDB_LOD=ON
	-DOPENVDB_BUILD_VDB_RENDER=ON
	-DOPENVDB_BUILD_VDB_VIEW=ON
	-DOPENVDB_CORE_SHARED=ON
	-DOPENVDB_CORE_STATIC=ON
	-DOPENVDB_ENABLE_RPATH=OFF
	-DUSE_BLOSC=ON
	-DUSE_ZLIB=ON
	-DUSE_CCACHE=OFF
	-DUSE_COLORED_OUTPUT=ON
	-DUSE_IMATH_HALF=ON
	-DUSE_LOG4CPLUS=ON
	-DUSE_NANOVDB=ON
	-DNANOVDB_BUILD_UNITTESTS=OFF
	-DNANOVDB_USE_CUDA=OFF # TODO
)

docmake "${CMAKEOPTS[@]}"

finalize
