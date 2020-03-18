#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/${PN}/${P}.tar.gz
acheck

importpkg media-libs/mesa X

cd "${T}"

docmake -DFREEGLUT_GLES=OFF -DFREEGLUT_BUILD_DEMOS=OFF -DFREEGLUT_BUILD_STATIC_LIBS=OFF \
	-DCMAKE_SYSTEM_INCLUDE_PATH="${CMAKE_INCLUDE_PATH}" -DCMAKE_SYSTEM_LIBRARY_PATH="${CMAKE_LIBRARY_PATH}"

make
make install DESTDIR="${D}"

finalize
