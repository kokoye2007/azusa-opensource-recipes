#!/bin/sh
source "../../common/init.sh"

get https://www.prelude-siem.org/attachments/download/1171/${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
