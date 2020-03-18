#!/bin/sh
source "../../common/init.sh"

get https://weechat.org/files/src/${P}.tar.xz

cd "${T}"

docmake -DMANDIR="/pkg/main/${PKG}.doc.${PVR}/man" -DNCURSES_INCLUDE_PATH="/pkg/main/sys-libs.ncurses.dev/include" -DNCURSESW_LIBRARY="/pkg/main/sys-libs.ncurses.dev/lib$LIB_SUFFIX/libncursesw.so"

make
make install DESTDIR="${D}"

finalize
