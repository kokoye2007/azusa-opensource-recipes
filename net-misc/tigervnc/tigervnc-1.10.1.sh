#!/bin/sh
source "../../common/init.sh"

get https://github.com/TigerVNC/${PN}/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

importpkg X

echo "CMAKE_INCLUDE_PATH=$CMAKE_INCLUDE_PATH"
docmake -DGETTEXT_INCLUDE_DIR=/pkg/main/sys-libs.glibc.dev/include -DCMAKE_SYSTEM_INCLUDE_PATH="${CMAKE_INCLUDE_PATH}" -DCMAKE_SYSTEM_LIBRARY_PATH="${CMAKE_LIBRARY_PATH}"
# -DX11_X11_INCLUDE_PATH=/pkg/main/x11-libs.libX11.dev/include

make
make install DESTDIR="${D}"

finalize
