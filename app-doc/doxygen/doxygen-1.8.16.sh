#!/bin/sh
source "../../common/init.sh"

get http://doxygen.nl/files/${P}.src.tar.gz
acheck

cd "${T}"

docmake
# TODO -Dbuild_doc=ON -Dbuild_wizard=ON -Dbuild_search=ON -Duse_libclang=ON

make
make install DESTDIR="${D}"

finalize
