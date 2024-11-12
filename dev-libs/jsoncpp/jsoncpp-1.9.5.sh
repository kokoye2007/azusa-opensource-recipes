#!/bin/sh
source "../../common/init.sh"

get https://github.com/open-source-parsers/"${PN}"/archive/"${PV}".tar.gz
acheck

cd "${T}" || exit

docmake -DJSONCPP_WITH_POST_BUILD_UNITTEST=OFF -DJSONCPP_WITH_CMAKE_PACKAGE=ON -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_INCLUDEDIR=include/jsoncpp -DCCACHE_FOUND=OFF

finalize
