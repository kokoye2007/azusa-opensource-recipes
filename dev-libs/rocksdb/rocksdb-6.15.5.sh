#!/bin/sh
source "../../common/init.sh"

get https://github.com/facebook/rocksdb/archive/refs/tags/v${PV}.tar.gz
acheck

cd "${S}"

MAKEOPTS=(
	PREFIX="/pkg/main/${PKG}.core.${PVRF}"
	LIBDIR="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"

	DESTDIR="${D}"
)

#make -j"$NPROC" install-static "${MAKEOPTS[@]}" DEBUG_LEVEL=1
#make -j"$NPROC" install-shared "${MAKEOPTS[@]}" DEBUG_LEVEL=1
make -j"$NPROC" install-static "${MAKEOPTS[@]}" DEBUG_LEVEL=0
make clean
make -j"$NPROC" install-shared "${MAKEOPTS[@]}" DEBUG_LEVEL=0

finalize
