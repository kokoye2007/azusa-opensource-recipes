#!/bin/sh
source "../../common/init.sh"

get http://doxygen.nl/files/${P}.src.tar.gz
acheck

cd "${P}"

importpkg dev-libs/xapian zlib

# ninja: error: rebuilding 'build.ninja': dependency cycle: examples/CMakeLists.txt -> examples/CMakeLists.txt
# solved with: -Dbuild_doc=OFF
docmake -Dbuild_doc=OFF -Dbuild_search=ON -DICONV_INCLUDE_DIR=/pkg/main/sys-libs.glibc.dev/include
# TODO -Duse_libclang=ON -Dbuild_wizard=ON

finalize
