#!/bin/sh
source "../../common/init.sh"

get https://github.com/uriparser/uriparser/releases/download/${P}/${P}.tar.bz2
acheck

cd "${T}"

docmake -DURIPARSER_BUILD_TESTS=OFF

make
make install DESTDIR="${D}"

finalize
