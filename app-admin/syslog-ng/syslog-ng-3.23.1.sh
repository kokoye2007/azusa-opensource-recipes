#!/bin/sh
source "../../common/init.sh"

get https://github.com/balabit/syslog-ng/releases/download/${P}/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
