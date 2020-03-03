#!/bin/sh
source "../../common/init.sh"

get https://poppler.freedesktop.org/${P}.tar.xz
acheck

cd "${T}"

docmake -DENABLE_UNSTABLE_API_ABI_HEADERS=ON -DICONV_INCLUDE_DIR=/pkg/main/sys-libs.glibc.dev/include -DICONV_LIBRARIES=

make VERBOSE=1
make install DESTDIR="${D}"

finalize
