#!/bin/sh
source "../../common/init.sh"

get https://sf.net/projects/libwpd/files/${PN}/${P}/${P}.tar.xz
acheck

cd "${T}"

importpkg dev-libs/boost

doconf --disable-werror --disable-static --with-docs

make
make install DESTDIR="${D}"

finalize
