#!/bin/sh
source "../../common/init.sh"

get https://github.com/SELinuxProject/selinux/releases/download/${PV}/${P}.tar.gz
acheck

importpkg sys-libs/libsepol

CPPFLAGS="${CPPFLAGS} -DPIE -fPIE -fno-semantic-interposition -Wno-stringop-truncation"
LDFLAGS="${LDFLAGS} -pthread"

cd "${S}"

MAKEOPTS=(
	USE_PCRE2=y
	CC="gcc ${CPPFLAGS}"
	LDFLAGS="${LDFLAGS}"
	PREFIX="/pkg/main/${PKG}.core.${PVRF}"
	LIBDIR="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	DESTDIR="${D}"
)

make "${MAKEOPTS[@]}"
make install "${MAKEOPTS[@]}"

finalize
