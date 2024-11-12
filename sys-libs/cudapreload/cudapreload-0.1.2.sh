#!/bin/sh
source "../../common/init.sh"

get https://github.com/AzusaOS/"${PN}"/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${S}" || exit

mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}/lib$LIB_SUFFIX"
if [ x"$LIB_SUFFIX" != x ]; then
	ln -snf "lib$LIB_SUFFIX" "${D}/pkg/main/${PKG}.dev.${PVRF}/lib"
fi

make
make install PREFIX="/pkg/main/${PKG}.dev.${PVRF}" LIBDIR="lib$LIB_SUFFIX" DESTDIR="${D}"

archive
