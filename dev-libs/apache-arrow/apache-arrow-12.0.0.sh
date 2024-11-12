#!/bin/sh
source "../../common/init.sh"

get https://archive.apache.org/dist/"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg zlib dev-libs/jemalloc app-arch/bzip2

CMAKEOPTS=(
	-DARROW_PARQUET=ON
	-DARROW_DEPENDENCY_SOURCE=SYSTEM
	-DARROW_BUILD_SHARED=ON
	-DARROW_JEMALLOC=OFF # can't get arrow to use system jemalloc
	-DARROW_WITH_BROTLI=ON
	-DARROW_WITH_BZ2=ON
	-DARROW_WITH_LZ4=TRUE
	-DARROW_WITH_SNAPPY=ON
	-DARROW_WITH_ZLIB=ON
	-DARROW_WITH_ZSTD=ON
	-DBOOST_INCLUDEDIR=/pkg/main/dev-libs.boost.dev/include
	-DBOOST_LIBRARYDIR=
	-DARROW_WITH_UTF8PROC=ON
	-DARROW_BUILD_UTILITIES=ON
	-DARROW_CSV=ON
	-DARROW_FILESYSTEM=ON

	-Dxsimd_DIR=/pkg/main/dev-libs.xsimd.dev/cmake/xsimd
)

CMAKE_ROOT="${S}/cpp" docmake "${CMAKEOPTS[@]}"

finalize
