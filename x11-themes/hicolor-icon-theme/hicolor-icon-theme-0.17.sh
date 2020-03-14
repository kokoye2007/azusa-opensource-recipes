#!/bin/sh
source "../../common/init.sh"

get https://icon-theme.freedesktop.org/releases/${P}.tar.xz
acheck

cd "${T}"

doconf

make install DESTDIR="${D}"

finalize
