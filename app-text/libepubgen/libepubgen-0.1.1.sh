#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/${PN}/${P}.tar.xz
acheck

cd "${T}"

importpkg dev-libs/boost

doconf --disable-weffc --with-docs

make
make install DESTDIR="${D}"

finalize
