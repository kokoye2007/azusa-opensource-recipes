#!/bin/sh
source "../../common/init.sh"

get https://github.com/protocolbuffers/${PN}/archive/v${PV}.tar.gz "${P}.tar.gz"
acheck

cd "${T}"

importpkg zlib dev-cpp/abseil-cpp

docmake -Dprotobuf_BUILD_TESTS=OFF -Dprotobuf_ABSL_PROVIDER=package -DCMAKE_PREFIX_PATH=/pkg/main/dev-cpp.abseil-cpp.dev

finalize
