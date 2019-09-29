#!/bin/sh
source "../../common/init.sh"

get https://github.com/systemd/systemd/archive/v${PV}/systemd-${PV}.tar.gz
acheck

cd "${T}"

importpkg sys-apps/kmod sys-libs/libcap

# TODO fix man
meson "${CHPATH}/systemd-${PV}" --prefix="/pkg/main/${PKG}.core.${PVR}" -Dacl=false -Defi=false -Dkmod=true -Dselinux=false -Dlink-udev-shared=false -Dsplit-usr=true -Dgcrypt=false -Dlibcryptsetup=false -Dlibidn=false -Dlibidn2=false -Dlibiptc=false -Dseccomp=false -Dlz4=false -Dxz=false -Dman=false

libudev=`readlink src/udev/libudev.so.1`
S="${CHPATH}/systemd-${PV}"

ninja src/udev/$libudev systemd-udevd udevadm src/udev/ata_id src/udev/cdrom_id src/udev/mtd_probe src/udev/scsi_id src/udev/v4l_id #man/udev.conf.5 man/systemd.link.5 man/hwdb.7 man/udev.7 man/systemd-udevd.service.8 man/udevadm.8

mkdir -p "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX"

install -vm755 src/udev/{${libudev},libudev.so.1,libudev.so} "${D}/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX"

mkdir -p "${D}/pkg/main/${PKG}.dev.${PVR}/pkgconfig"
install -vm644 src/libudev/libudev.pc src/udev/udev.pc "${D}/pkg/main/${PKG}.dev.${PVR}/pkgconfig"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}/bin"
install -vm755 udevadm "${D}/pkg/main/${PKG}.core.${PVR}/bin"
mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}"/lib/{systemd,udev}
install -vm755 systemd-udevd "${D}/pkg/main/${PKG}.core.${PVR}/lib/systemd"
install -vm755 src/udev/{ata_id,cdrom_id,mtd_probe,scsi_id,v4l_id} "${D}/pkg/main/${PKG}.core.${PVR}/lib/udev"

#mkdir -p "${D}/pkg/main/${PKG}.doc.${PVR}/man"
#mv man/systemd-udevd.service.8 man/systemd-udevd.8
#rm man/systemd-udevd-{control,kernel}.socket.8
#mv man/*.[0-9] "${D}/pkg/main/${PKG}.doc.${PVR}/man"

mkdir -p "${D}/pkg/main/${PKG}.dev.${PVR}/include"
install -vm644 "${S}/src/libudev/libudev.h" "${D}/pkg/main/${PKG}.dev.${PVR}/include"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}/lib/udev/rules.d"

install -vm644 ${S}/rules/*.rules "${D}/pkg/main/${PKG}.core.${PVR}/lib/udev/rules.d"

finalize
