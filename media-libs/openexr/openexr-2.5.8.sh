#!/bin/sh
source "../../common/init.sh"

get https://github.com/AcademySoftwareFoundation/openexr/archive/refs/tags/v${PV}.tar.gz "${P}.tar.gz"
acheck

cd "${T}"

importpkg zlib

docmake -DBUILD_SHARED_LIBS=ON -DBUILD_TESTING=OFF -DOPENEXR_BUILD_UTILS=ON -DOPENEXR_ENABLE_LARGE_STACK=ON -DOPENEXR_ENABLE_THREADING=ON -DOPENEXR_INSTALL_EXAMPLES=ON -DOPENEXR_INSTALL_PKG_CONFIG=ON -DOPENEXR_INSTALL_TOOLS=ON -DOPENEXR_USE_CLANG_TIDY=OFF

finalize
