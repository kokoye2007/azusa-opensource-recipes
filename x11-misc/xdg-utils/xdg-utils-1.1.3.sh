#!/bin/sh
source "../../common/init.sh"

get https://portland.freedesktop.org/download/${P}.tar.gz
acheck

cd "${P}"

doconf

make
make install DESTDIR="${D}"

finalize
