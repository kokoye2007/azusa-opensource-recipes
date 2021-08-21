#!/bin/sh
source "../../common/init.sh"

get https://dbus.freedesktop.org/releases/dbus/${P}.tar.gz
acheck

cd "${T}"

importpkg X

doconf --sysconfdir=/etc --enable-user-session --disable-xml-docs --disable-static --with-systemduserunitdir=no --with-systemdsystemunitdir=no --with-console-auth-dir=/var/run/console --with-system-pid-file=/var/run/dbus/pid --with-system-socket=/var/run/dbus/system_bus_socket

make
make install DESTDIR="${D}"

finalize
