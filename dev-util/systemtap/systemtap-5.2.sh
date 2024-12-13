#!/bin/sh
source "../../common/init.sh"

get https://www.sourceware.org/systemtap/ftp/releases/${P}.tar.gz
acheck

cd "${T}"

importpkg libelf sqlite3 net-dns/avahi dev-libs/nss dev-libs/json-c sys-libs/ncurses

doconf

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
