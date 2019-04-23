#!/bin/sh
source "../../common/init.sh"

get https://launchpad.net/intltool/trunk/${PV}/+download/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
