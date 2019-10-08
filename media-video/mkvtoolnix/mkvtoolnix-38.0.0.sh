#!/bin/sh
source "../../common/init.sh"

get https://mkvtoolnix.download/sources/${P}.tar.xz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
