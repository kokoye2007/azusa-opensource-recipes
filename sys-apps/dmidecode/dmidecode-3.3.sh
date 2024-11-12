#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.gnu.org/releases/"${PN}"/"${P}".tar.xz
acheck

cd "${P}" || exit

MAKEOPTS=(
	DESTDIR="${D}"
	prefix="/pkg/main/${PKG}.core.${PVRF}"
	mandir="/pkg/main/${PKG}.doc.${PVRF}/man"
	docdir="/pkg/main/${PKG}.doc.${PVRF}"
)

make "${MAKEOPTS[@]}"
make install "${MAKEOPTS[@]}"

finalize
