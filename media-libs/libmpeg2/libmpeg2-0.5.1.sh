#!/bin/sh
source "../../common/init.sh"

get http://libmpeg2.sourceforge.net/files/${P}.tar.gz
acheck

cd "${T}"

importpkg media-libs/libsdl

doconf

make
make install DESTDIR="${D}"

finalize
