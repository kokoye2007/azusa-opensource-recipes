#!/bin/sh
source ../../common/init.sh
inherit python
inherit cuda

initcuda 12.1

get https://github.com/pytorch/vision/archive/refs/tags/v${PV}.tar.gz $P.tar.gz
acheck

importpkg sys-libs/llvm-libunwind # needed quite often
importpkg dev-cpp/gflags sci-libs/caffe2

export MAX_JOBS=1

cd "${S}"

pythonsetup
archive
