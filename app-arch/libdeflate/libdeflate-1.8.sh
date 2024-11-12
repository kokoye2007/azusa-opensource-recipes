#!/bin/sh
source "../../common/init.sh"

get https://github.com/ebiggers/libdeflate/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${P}" || exit

MAKEOPTS=(
	USE_SHARED_LIB=1
	PREFIX="/pkg/main/${PKG}.core.${PVRF}"
	INCDIR="/pkg/main/${PKG}.dev.${PVRF}/include"
	LIBDIR="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	DESTDIR="${D}"
)

make "${MAKEOPTS[@]}"
make "${MAKEOPTS[@]}" install

finalize
