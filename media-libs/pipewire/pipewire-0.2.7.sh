#!/bin/sh
source "../../common/init.sh"

get https://github.com/PipeWire/pipewire/archive/"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

meson "${CHPATH}/${P}" --prefix=/pkg/main/"${PKG}".core."${PVRF}" --sysconfdir=/etc

ninja
DESTDIR="${D}" ninja install

finalize
