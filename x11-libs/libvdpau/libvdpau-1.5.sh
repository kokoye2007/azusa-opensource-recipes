#!/bin/sh
source "../../common/init.sh"

get https://gitlab.freedesktop.org/vdpau/libvdpau/-/archive/${PV}/${P}.tar.bz2
acheck

cd "${T}"

importpkg X

domeson

finalize
