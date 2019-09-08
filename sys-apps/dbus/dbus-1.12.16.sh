#!/bin/sh
source "../../common/init.sh"

get https://dbus.freedesktop.org/releases/dbus/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
