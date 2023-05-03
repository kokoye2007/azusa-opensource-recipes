#!/bin/sh
source "../../common/init.sh"

get https://github.com/onnx/${PN}/archive/refs/tags/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

importpkg dev-libs/protobuf

docmake -DONNX_USE_PROTOBUF_SHARED_LIBS=ON

finalize
