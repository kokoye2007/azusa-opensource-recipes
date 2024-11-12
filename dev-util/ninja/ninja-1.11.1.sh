#!/bin/sh
source "../../common/init.sh"

get https://github.com/ninja-build/ninja/archive/v"${PV}".tar.gz
acheck

cd "${P}" || exit

if [ "$ARCH" = "386" ]; then
	# enable 64bit mode
	# see: https://github.com/ninja-build/ninja/issues/829
	export CPPFLAGS="${CPPFLAGS} -D_LARGEFILE_SOURCE -D_FILE_OFFSET_BITS=64"
fi

CFLAGS="${CPPFLAGS}" python3 configure.py --bootstrap --verbose

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
install -vm755 ninja "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

finalize
