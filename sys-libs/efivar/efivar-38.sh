#!/bin/sh
source "../../common/init.sh"

get https://github.com/rhinstaller/efivar/releases/download/${PV}/${P}.tar.bz2
acheck

cd "${S}"

PATCHES=(
	"${FILESDIR}"/efivar-38-march-native.patch
	"${FILESDIR}"/efivar-38-Makefile-dep.patch
	"${FILESDIR}"/efivar-38-binutils-2.36.patch
	"${FILESDIR}"/efivar-38-ld-locale.patch
	"${FILESDIR}"/efivar-38-glibc-2.36.patch
	"${FILESDIR}"/efivar-38-lld-fixes.patch
	"${FILESDIR}"/efivar-38-efisecdb-musl.patch
	"${FILESDIR}"/efivar-38-efisecdb-optarg.patch

	# Rejected upstream, keep this for ia64 support
	"${FILESDIR}"/efivar-38-ia64-relro.patch
)
apatch "${PATCHES[@]}"

#sed -i -e 's/-Werror //' gcc.specs

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
