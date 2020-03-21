#!/bin/sh
source "../../common/init.sh"

get https://github.com/nodejs/${PN}/archive/v${PV}.tar.gz
acheck

cd "${P}"

MAKEOPTS=(
	PREFIX="/pkg/main/${PKG}.core.${PVRF}"
	LIBDIR="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	DESTDIR="${D}"
)

make "${MAKEOPTS[@]}" library
make "${MAKEOPTS[@]}" install

finalize
