#!/bin/sh
source "../../common/init.sh"

get https://gitlab.freedesktop.org/wayland/"${PN}"/-/releases/"${PV}"/downloads/"${P}".tar.xz
acheck

cd "${T}" || exit

domeson

finalize
