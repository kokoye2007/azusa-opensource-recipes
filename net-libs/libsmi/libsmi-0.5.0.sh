#!/bin/sh
source "../../common/init.sh"

get https://www.ibr.cs.tu-bs.de/projects/libsmi/download/${P}.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
