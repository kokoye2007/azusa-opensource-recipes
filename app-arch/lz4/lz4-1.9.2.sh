#!/bin/sh
source "../../common/init.sh"

get https://github.com/lz4/lz4/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

CMAKE_ROOT=${S}/contrib/cmake_unofficial
docmake -DBUILD_STATIC_LIBS=NO

make
make install DESTDIR="${D}"

finalize
