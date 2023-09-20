#!/bin/sh
source "../../common/init.sh"

get https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

importpkg zlib libpng

docmake -DBUILD_LENSTOOL=ON -DCMAKE_INSTALL_DOCDIR="/pkg/main/${PKG}.doc.${PVRF}/html" -DBUILD_DOC=ON -DBUILD_TESTS=OFF
# -DBUILD_FOR_SSE=
# -DBUILD_FOR_SSE2=

finalize
