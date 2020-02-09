#!/bin/sh
source "../../common/init.sh"

get https://osdn.net/dl/anthy/anthy-9100h.tar.gz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
