#!/bin/sh
source "../../common/init.sh"

get https://www.nih.at/libzip/${P}.tar.xz
acheck

cd "${T}"

docmake -DBUILD_SHARED_LIBS=ON -DZLIB_ROOT=/pkg/main/sys-libs.zlib.dev -DCMAKE_PREFIX_PATH=/pkg/main/app-arch.bzip2.dev

make
make install DESTDIR="${D}"

finalize
