#!/bin/sh
source "../../common/init.sh"

MOZVER=39
get https://github.com/cisco/"${PN}"/archive/v"${PV}".tar.gz "${P}".tar.gz
get https://github.com/mozilla/gmp-api/archive/Firefox${MOZVER}.tar.gz gmp-api-Firefox${MOZVER}.tar.gz
acheck

cd "${S}" || exit

ln -s "$CHPATH/gmp-api-Firefox${MOZVER}" gmp-api

MAKEOPTS=(
	CFLAGS_M32=""
	CFLAGS_M64=""
	CFLAGS_OPT=""
	V=Yes
	PREFIX="/pkg/main/${PKG}.core.${PVRF}"
	LIBDIR_NAME="lib$LIB_SUFFIX"
	SHAREDLIB_DIR="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	INCLUDES_DIR="/pkg/main/${PKG}.dev.${PVRF}/include/${PN}"
)

make "${MAKEOPTS[@]}" ENABLE64BIT=Yes
make install-shared "${MAKEOPTS[@]}" DESTDIR="${D}"

finalize
