#!/bin/sh
source ../../common/init.sh
inherit python

importpkg zlib

# https://gitlab.kitware.com/cmake/cmake/-/issues/25777
export ZLIB_ROOT=/pkg/main/sys-libs.zlib.dev

export PYARROW_BUILD_VERBOSE=1
export PYARROW_CXXFLAGS="${CPPFLAGS} ${LDFLAGS} ${CXXFLAGS}"
export PYARROW_BUNDLE_ARROW_CPP_HEADERS=0
export PYARROW_CMAKE_GENERATOR=Ninja
export PYARROW_WITH_HDFS=1
export PYARROW_WITH_DATASET=1
export PYARROW_WITH_PARQUET=1
export PYARROW_WITH_PARQUET_ENCRYPTION=1
export PYARROW_WITH_SNAPPY=1

PATCHES=("$FILESDIR/pyarrow-15.0.1-fix-python3.12-detection-of-suffix-arrow-bug-40566.patch")

python_do_standard_package
