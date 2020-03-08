#!/bin/sh
source "../../common/init.sh"

get http://doxygen.nl/files/${P}.src.tar.gz
acheck

cd "${P}"

docmake -Dbuild_doc=ON -Dbuild_search=ON -DICONV_INCLUDE_DIR=/pkg/main/sys-libs.glibc.dev/include || /bin/bash -i
# TODO -Duse_libclang=ON -Dbuild_wizard=ON

make
make install DESTDIR="${D}"

finalize
