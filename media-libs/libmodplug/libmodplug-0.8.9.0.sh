#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/project/modplug-xmms/libmodplug/${PV}/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
