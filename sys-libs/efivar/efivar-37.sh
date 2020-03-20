#!/bin/sh
source "../../common/init.sh"

get https://github.com/rhinstaller/efivar/releases/download/${PV}/${P}.tar.bz2
acheck

cd "${S}"

sed -i -e 's/-Werror //' gcc.specs

MAKEOPTS=(
	PREFIX="/pkg/main/${PKG}.core.${PVR}"
	LIBDIR="/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX"
	MANDIR="/pkg/main/${PKG}.doc.${PVR}/man"
	INCLUDEDIR="/pkg/main/${PKG}.dev.${PVR}/include"
	PCDIR="/pkg/main/${PKG}.dev.${PVR}/pkgconfig"
	DESTDIR="${D}"
)

make "${MAKEOPTS[@]}" all
make "${MAKEOPTS[@]}" install

finalize
