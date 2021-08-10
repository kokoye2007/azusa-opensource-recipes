#!/bin/sh
source "../../common/init.sh"

get https://github.com/pmem/${PN}/releases/download/${PV}/${P}.tar.gz
acheck

cd "${S}"

importpkg ncurses libuv

MAKEOPTS=(
	prefix="/pkg/main/${PKG}.core.${PVRF}"
	libdir="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	DESTDIR="${D}"
	EXTRA_CFLAGS="${CPPFLAGS}"
)

make "${MAKEOPTS[@]}"
make install "${MAKEOPTS[@]}"

finalize
