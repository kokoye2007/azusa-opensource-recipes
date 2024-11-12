#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.altlinux.org/pub/people/ldv/"${PN}"/"${P}".tar.gz
acheck

cd "${S}" || exit

MAKEOPTS=(
	libdir=/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX
	libexecdir=/pkg/main/${PKG}.libs.${PVRF}/libexec
	includedir=/pkg/main/${PKG}.dev.${PVRF}/include
	mandir=/pkg/main/${PKG}.doc.${PVRF}/man
	DESTDIR="${D}"
)

make "${MAKEOPTS[@]}"
make install "${MAKEOPTS[@]}"

finalize
