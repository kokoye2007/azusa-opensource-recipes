#!/bin/sh
source "../../common/init.sh"

get https://github.com/rhinstaller/efivar/releases/download/${PV}/${P}.tar.bz2
acheck

cd "${S}"

sed -i -e 's/-Werror //' gcc.specs

MAKEOPTS=(
	PREFIX="/pkg/main/${PKG}.core.${PVRF}"
	LIBDIR="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	MANDIR="/pkg/main/${PKG}.doc.${PVRF}/man"
	INCLUDEDIR="/pkg/main/${PKG}.dev.${PVRF}/include"
	PCDIR="/pkg/main/${PKG}.dev.${PVRF}/pkgconfig"
	DESTDIR="${D}"
)

make "${MAKEOPTS[@]}" all
make "${MAKEOPTS[@]}" install

finalize
