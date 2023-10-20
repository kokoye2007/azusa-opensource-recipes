#!/bin/sh
source "../../common/init.sh"

get https://github.com/RadeonOpenCompute/ROCR-Runtime/archive/rocm-${PV}.tar.gz "${P}.tar.gz"
acheck

cd "${T}"

S="${S}/src"

importpkg dev-libs/libelf zlib

docmake

finalize
