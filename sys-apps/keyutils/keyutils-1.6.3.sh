#!/bin/sh
source "../../common/init.sh"

get https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/keyutils.git/snapshot/${P}.tar.gz
acheck

cd "${S}"

MAKEOPTS=(
	PREFIX="/pkg/main/${PKG}.core.${PVRF}"
	BINDIR="/pkg/main/${PKG}.core.${PVRF}/bin"
	SBINDIR="/pkg/main/${PKG}.core.${PVRF}/sbin"
	LIBDIR="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	SHAREDIR="/pkg/main/${PKG}.core.${PVRF}/share"
	MANDIR="/pkg/main/${PKG}.doc.${PVRF}/man"
	INCLUDEDIR="/pkg/main/${PKG}.dev.${PVRF}/include"
	DESTDIR="${D}"
)

make "${MAKEOPTS[@]}"
make install "${MAKEOPTS[@]}"

finalize
