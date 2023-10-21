#!/bin/sh
source "../../common/init.sh"

get https://github.com/Exiv2/exiv2/archive/refs/tags/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

importpkg zlib app-arch/brotli dev-libs/inih

docmake -DEXIV2_ENABLE_VIDEO=yes -DEXIV2_ENABLE_WEBREADY=yes -DEXIV2_ENABLE_CURL=yes -DEXIV2_BUILD_SAMPLES=no

finalize
