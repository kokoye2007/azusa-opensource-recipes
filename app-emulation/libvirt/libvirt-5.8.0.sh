#!/bin/sh
source "../../common/init.sh"

get https://libvirt.org/sources/${P}.tar.xz
acheck

cd "${T}"

importpkg sys-apps/attr sys-process/audit libtirpc dev-libs/yajl sys-fs/lvm2 libsasl2

CONFIGURE=(
	--with-packager="AZUSA"
	--with-qemu
	--with-attr
	--with-audit
	--with-blkid
	#--with-capng
	--with-curl
	--with-dbus
	#--with-fuse
	--with-libxml
	--with-polkit
	--with-readline
	--with-ssh2
	--with-udev
	--with-lxc
)

doconf "${CONFIGURE[@]}" || /bin/bash -i

make
make install DESTDIR="${D}"

finalize
