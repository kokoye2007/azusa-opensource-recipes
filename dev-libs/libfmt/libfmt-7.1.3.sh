#!/bin/sh
source "../../common/init.sh"

get https://github.com/fmtlib/fmt/archive/${PV}.tar.gz
acheck

cd "${T}"

docmake -DFMT_CMAKE_DIR=/pkg/main/${PKG}.dev.${PVRF}/cmake/fmt -DFMT_LIB_DIR=/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX -DFMT_TEST=NO

make
make install DESTDIR="${D}"

finalize
