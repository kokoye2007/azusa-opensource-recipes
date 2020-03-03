#!/bin/sh
source "../../common/init.sh"

get https://github.com/nodejs/${PN}/archive/v${PV}.tar.gz
acheck

cd "${P}"

MAKEOPTS=(
	PREFIX="/pkg/main/${PKG}.core.${PVR}"
	LIBDIR="/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX"
	DESTDIR="${D}"
)

make "${MAKEOPTS[@]}" library
make "${MAKEOPTS[@]}" install

finalize
