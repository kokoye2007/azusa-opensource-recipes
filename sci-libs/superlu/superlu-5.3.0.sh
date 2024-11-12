#!/bin/sh
source "../../common/init.sh"

get https://github.com/xiaoyeli/superlu/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

docmake -DCMAKE_INSTALL_INCLUDEDIR="include/superlu" -DBUILD_SHARED_LIBS=ON -Denable_internal_blaslib=OFF -Denable_tests=OFF

finalize
