#!/bin/sh
source "../../common/init.sh"

get https://github.com/lz4/lz4/archive/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

CMAKE_ROOT=${S}/build/cmake
docmake -DBUILD_STATIC_LIBS=NO

finalize
