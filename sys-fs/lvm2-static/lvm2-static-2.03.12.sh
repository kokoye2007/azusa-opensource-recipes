#!/bin/sh
source "../../common/init.sh"

get http://mirrors.kernel.org/sourceware/lvm2/LVM2."${PV}".tgz
acheck

cd "${T}" || exit

importpkg dev-libs/libaio
export CFLAGS="$CPPFLAGS"

doconf --enable-static_link --disable-readline --disable-use-lvmlockd --disable-use-lvmpolld --disable-udev_sync --disable-udev_rules --disable-dbus-service --disable-selinux

make STATIC_LIBS="-lpthread -lm" interfacebuilddir="$PWD/libdm/ioctl" || /bin/bash -i
make install DESTDIR="${D}"

finalize
