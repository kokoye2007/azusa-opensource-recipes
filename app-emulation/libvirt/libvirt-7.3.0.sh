#!/bin/sh
source "../../common/init.sh"

get https://libvirt.org/sources/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg sys-apps/attr sys-process/audit libtirpc dev-libs/yajl sys-fs/lvm2 libsasl2

MESONOPTS=(
	-Dpackager=AZUSA
	-Ddriver_qemu=enabled
)

domeson "${MESONOPTS[@]}"

ninja
DESTDIR="${D}" ninja install

finalize
