#!/bin/sh
source "../../common/init.sh"

get https://github.com/SELinuxProject/selinux/releases/download/20191204/${P}.tar.gz
acheck

importpkg sys-libs/libsepol

cd "${S}"

MAKEOPTS=(
	USE_PCRE2=y
	PREFIX="/pkg/main/${PKG}.core.${PVRF}"
	LIBDIR="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	DESTDIR="${D}"
)

make "${MAKEOPTS[@]}"
make install "${MAKEOPTS[@]}"

finalize
