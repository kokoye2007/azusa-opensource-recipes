#!/bin/sh
source "../../common/init.sh"

get https://github.com/erincatto/Box2D/archive/v"${PV}".tar.gz
acheck

cd "${T}" || exit

docmake -DBOX2D_BUILD_TESTBED=OFF -DBOX2D_BUILD_DOCS=ON

make
make install DESTDIR="${D}"

finalize
