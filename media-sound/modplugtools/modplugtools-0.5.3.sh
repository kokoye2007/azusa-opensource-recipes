#!/bin/sh
source "../../common/init.sh"

get https://download.sourceforge.net/modplug-xmms/${P}.tar.gz
acheck
prepare

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
