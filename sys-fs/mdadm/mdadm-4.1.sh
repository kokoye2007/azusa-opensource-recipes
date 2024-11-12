#!/bin/sh
source "../../common/init.sh"

get https://www.kernel.org/pub/linux/utils/raid/mdadm/"${P}".tar.xz
acheck

cd "${P}" || exit

sed 's@-Werror@@' -i Makefile

make
make install DESTDIR="${D}" BINDIR="/pkg/main/${PKG}.core.${PVR}/sbin" MANDIR="/pkg/main/${PKG}.doc.${PVR}/man"

# install static mdadm in dev pkg (used for initramfs, etc)
make mdadm.static
/usr/bin/install -D -m 755 mdadm.static "${D}/pkg/main/${PKG}.dev.${PVR}/sbin/mdadm.static"

finalize
