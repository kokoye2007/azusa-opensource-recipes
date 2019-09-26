#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/${PN}/${P}.tar.gz

cd "${T}"

importpkg media-sound/gsm media-sound/lame libpng

doconf

make
make install DESTDIR="${D}"

finalize
