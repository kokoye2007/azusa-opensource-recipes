#!/bin/sh
source "../../common/init.sh"

get https://gitlab.archlinux.org/pacman/pacman/-/archive/v${PV}/${PN}-v${PV}.tar.bz2 ${P}.tar.bz2
acheck

cd "${T}"

importpkg app-arch/libarchive

domeson -Dbuildstatic=false --localstatedir "/var" -Droot-dir="/var/chroot/archlinux" -Dcurl=enabled -Dgpgme=enabled -Ddoxygen=enabled

finalize
