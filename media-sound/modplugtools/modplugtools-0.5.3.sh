#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/modplug-xmms/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
