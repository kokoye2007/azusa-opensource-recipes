#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/${PN}/${P}.tar.xz
acheck

cd "${T}"

importpkg sys-apps/util-linux sys-fs/lvm2 sys-libs/readline sys-libs/ncurses

doconf

# fix calls to major() and minor()
echo "#include <sys/sysmacros.h>" >>lib/config.h

make
make install DESTDIR="${D}"

finalize
