#!/bin/sh
source "../../common/init.sh"

get https://github.com/facebook/zstd/releases/download/v"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

CMAKE_ROOT="${CHPATH}/${P}/build/cmake" docmake

finalize
