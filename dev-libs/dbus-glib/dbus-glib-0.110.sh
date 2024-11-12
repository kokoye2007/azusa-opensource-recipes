#!/bin/sh
source "../../common/init.sh"

get https://dbus.freedesktop.org/releases/dbus-glib/"${P}".tar.gz

cd "${T}" || exit

doconf --sysconfdir=/etc --disable-static

make
make install DESTDIR="${D}"

finalize
