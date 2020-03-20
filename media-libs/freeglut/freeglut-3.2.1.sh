#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/${PN}/${P}.tar.gz
acheck

importpkg media-libs/mesa X

cd "${T}"

docmake -DFREEGLUT_GLES=OFF -DFREEGLUT_BUILD_DEMOS=OFF -DFREEGLUT_BUILD_STATIC_LIBS=OFF

make
make install DESTDIR="${D}"

finalize
