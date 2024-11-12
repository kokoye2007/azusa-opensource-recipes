#!/bin/sh
source "../../common/init.sh"

get https://wpewebkit.org/releases/"${P}".tar.xz
acheck

importpkg x11-base/xorg-proto x11-libs/libX11 x11-libs/libxkbcommon

cd "${T}" || exit

docmake -DBUILD_DOCS=OFF

make
make install DESTDIR="${D}"

finalize
