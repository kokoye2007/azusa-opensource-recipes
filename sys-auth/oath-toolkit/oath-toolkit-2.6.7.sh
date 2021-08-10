#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.gnu.org/releases/${PN}/${P}.tar.gz
acheck

cd "${T}"

importpkg sys-devel/libtool

doconf

make
make install DESTDIR="${D}"

finalize
