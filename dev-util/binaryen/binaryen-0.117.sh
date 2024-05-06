#!/bin/sh
source "../../common/init.sh"

get https://github.com/WebAssembly/binaryen/archive/refs/tags/version_${PV/*.}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

docmake -DBUILD_TESTS=OFF

finalize
