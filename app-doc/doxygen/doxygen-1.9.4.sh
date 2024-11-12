#!/bin/sh
source "../../common/init.sh"

get http://doxygen.nl/files/"${P}".src.tar.gz
acheck

cd "${S}" || exit

apatch "$FILESDIR/doxygen-1.9.4-gcc12-include.patch"

cd "${T}" || exit

importpkg dev-libs/xapian zlib sqlite3

# dev-texlive/texlive-fontutils is required for -Dbuild_doc=ON + CMAKE_EXTRA_TARGETS="docs"
#CMAKE_EXTRA_TARGETS="docs" docmake -Dbuild_doc=ON -Dbuild_search=ON -Duse_sqlite3=ON -DICONV_INCLUDE_DIR=/pkg/main/sys-libs.glibc.dev/include
docmake -Dbuild_doc=OFF -Dbuild_search=ON -Duse_sqlite3=ON -DICONV_INCLUDE_DIR=/pkg/main/sys-libs.glibc.dev/include

# TODO -Duse_libclang=ON -Dbuild_wizard=ON

finalize
