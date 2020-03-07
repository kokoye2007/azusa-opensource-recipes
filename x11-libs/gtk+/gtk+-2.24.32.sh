#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/gtk+/${PV%.*}/${P}.tar.xz
acheck

cd "${T}"

importpkg sys-apps/util-linux app-arch/bzip2 dev-libs/libbsd net-print/cups

doconf

make
make install DESTDIR="${D}"

finalize
