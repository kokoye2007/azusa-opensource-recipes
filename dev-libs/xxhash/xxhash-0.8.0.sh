#!/bin/sh
source "../../common/init.sh"

get https://github.com/Cyan4973/xxHash/archive/v"${PV}".tar.gz
acheck

cd "${S}" || exit

# do not define libdir as it'd prevent generation of pkg-config file, instead let finalize cleanup the thing
MAKEOPTS=(
	PREFIX="/pkg/main/${PKG}.core.${PVRF}"
	#LIBDIR="/plg/main/${PKG}.libs.${PVRF}"
	#INCLUDEDIR="/pkg/main/${PKG}.dev.${PVRF}/include"
	datarootdir="/pkg/main/${PKG}.doc.${PVRF}"
	DESTDIR="${D}"
)

make "${MAKEOPTS[@]}"
make install "${MAKEOPTS[@]}"

finalize
