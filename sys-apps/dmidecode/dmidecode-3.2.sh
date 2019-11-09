#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.gnu.org/releases/${PN}/${P}.tar.xz
acheck

cd "${P}"

MAKEOPTS=(
	DESTDIR="${D}"
	prefix="/pkg/main/${PKG}.core.${PVR}"
	mandir="/pkg/main/${PKG}.doc.${PVR}/man"
	docdir="/pkg/main/${PKG}.doc.${PVR}"
)

make "${MAKEOPTS[@]}"
make install "${MAKEOPTS[@]}"

finalize
