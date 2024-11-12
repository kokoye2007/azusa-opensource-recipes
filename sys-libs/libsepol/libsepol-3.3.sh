#!/bin/sh
source "../../common/init.sh"

MY_PV="${PV//_/-}"
MY_P="${PN}-${MY_PV}"

get https://github.com/SELinuxProject/selinux/releases/download/"${MY_PV}"/"${MY_P}".tar.gz
acheck

cd "${S}" || exit

MAKEOPTS=(
	PREFIX="/pkg/main/${PKG}.core.${PVRF}"
	LIBDIR="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	DESTDIR="${D}"
)

make "${MAKEOPTS[@]}"
make install "${MAKEOPTS[@]}"

finalize
