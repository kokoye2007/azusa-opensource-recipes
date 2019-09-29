#!/bin/sh
source "../../common/init.sh"

get https://github.com/PipeWire/pipewire/archive/${PV}/${P}.tar.gz
acheck

cd "${T}"

meson "${CHPATH}/${P}" --prefix=/pkg/main/${PKG}.core.${PVR} --sysconfdir=/etc

ninja
DESTDIR="${D}" ninja install

finalize
