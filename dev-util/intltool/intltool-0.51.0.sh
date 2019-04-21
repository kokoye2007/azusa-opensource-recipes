#!/bin/sh
source "../../common/init.sh"

get https://launchpad.net/intltool/trunk/${PV}/+download/${P}.tar.gz

cd "${T}"

doconf

make >make.log 2>&1
make >make_install.log 2>&1 install DESTDIR="${D}"

finalize
