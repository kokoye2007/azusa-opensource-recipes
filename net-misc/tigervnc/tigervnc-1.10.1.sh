#!/bin/sh
source "../../common/init.sh"

get https://github.com/TigerVNC/${PN}/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

docmake -DX11_X11_INCLUDE_PATH=/pkg/main/x11-libs.libX11.dev/include

make
make install DESTDIR="${D}"

finalize
