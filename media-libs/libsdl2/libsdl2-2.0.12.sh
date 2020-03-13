#!/bin/sh
source "../../common/init.sh"

get http://www.libsdl.org/release/SDL2-${PV}.tar.gz
acheck

cd "SDL2-${PV}"

importpkg sys-fs/udev app-i18n/ibus dev-libs/wayland X

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
