#!/bin/sh
source "../../common/init.sh"

get https://www.nano-editor.org/dist/v4/${P}.tar.xz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
