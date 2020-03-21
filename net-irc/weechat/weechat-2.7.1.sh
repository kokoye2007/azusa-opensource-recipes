#!/bin/sh
source "../../common/init.sh"

get https://weechat.org/files/src/${P}.tar.xz

cd "${T}"

importpkg dev-libs/libgcrypt sys-libs/ncurses sys-libs/zlib net-libs/gnutls app-text/aspell sys-libs/glibc dev-lang/lua dev-lang/tcl dev-libs/libgpg-error dev-libs/libatomic_ops

docmake -DMANDIR="/pkg/main/${PKG}.doc.${PVRF}/man" -DENABLE_LUA=OFF -DENABLE_PHP=OFF -DENABLE_JAVASCRIPT=OFF

make
make install DESTDIR="${D}"

finalize
