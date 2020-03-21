#!/bin/sh
source "../../common/init.sh"

get https://github.com/systemd/systemd/archive/v${PV}/systemd-${PV}.tar.gz
echo "udev disabled, use eudev"
exit 1
acheck

cd "${T}"

importpkg sys-apps/kmod sys-libs/libcap sys-process/audit

meson "${CHPATH}/systemd-${PV}" --prefix="/pkg/main/${PKG}.core.${PVRF}" -Dacl=false -Defi=false -Dkmod=true -Dselinux=false -Dlink-udev-shared=false -Dsplit-usr=true -Dgcrypt=false -Dlibcryptsetup=false -Dlibidn=false -Dlibidn2=false -Dlibiptc=false -Dseccomp=false -Dlz4=false -Dxz=false

libudev=`readlink src/udev/libudev.so.1`
#S="${CHPATH}/systemd-${PV}"

ninja src/udev/$libudev systemd-udevd udevadm src/udev/ata_id src/udev/cdrom_id src/udev/mtd_probe src/udev/scsi_id src/udev/v4l_id man/udev.conf.5 man/systemd.link.5 man/hwdb.7 man/udev.7 man/systemd-udevd.service.8 man/udevadm.8

mkdir -p "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"

install -vm755 src/udev/{${libudev},libudev.so.1,libudev.so} "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"

mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}/pkgconfig"
#install -vm644 src/libudev/libudev.pc src/udev/udev.pc "${D}/pkg/main/${PKG}.dev.${PVRF}/pkgconfig"
cat >"${D}/pkg/main/${PKG}.dev.${PVRF}/pkgconfig/udev.pc" <<EOF
Name: udev
Description: udev
Version: ${PV}

udevdir=/pkg/main/${PKG}.core.${PVRF}/lib/udev
EOF

cat >"${D}/pkg/main/${PKG}.dev.${PVRF}/pkgconfig/libudev.pc" <<EOF
#  SPDX-License-Identifier: LGPL-2.1+
#
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it
#  under the terms of the GNU Lesser General Public License as published by
#  the Free Software Foundation; either version 2.1 of the License, or
#  (at your option) any later version.

prefix=/pkg/main/${PKG}.core.${PVRF}
exec_prefix=/pkg/main/${PKG}.core.${PVRF}
libdir=/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX
includedir=/pkg/main/${PKG}.dev.${PVRF}/include

Name: libudev
Description: Library to access udev device information
Version: ${PV}
Libs: -L\${libdir} -ludev
Cflags: -I\${includedir}
EOF

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
install -vm755 udevadm "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}"/{systemd,udev}
install -vm755 systemd-udevd "${D}/pkg/main/${PKG}.core.${PVRF}/systemd"
install -vm755 src/udev/{ata_id,cdrom_id,mtd_probe,scsi_id,v4l_id} "${D}/pkg/main/${PKG}.core.${PVRF}/udev"

mkdir -pv "${D}/pkg/main/${PKG}.doc.${PVRF}/man"
mv -v man/systemd-udevd.service.8 man/systemd-udevd.8
rm -v man/systemd-udevd-{control,kernel}.socket.8
mv -v man/*.[0-9] "${D}/pkg/main/${PKG}.doc.${PVRF}/man"

mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}/include"
install -vm644 "${S}/src/libudev/libudev.h" "${D}/pkg/main/${PKG}.dev.${PVRF}/include"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/udev/rules.d"

install -vm644 ${S}/rules/*.rules "${D}/pkg/main/${PKG}.core.${PVRF}/udev/rules.d"

archive
