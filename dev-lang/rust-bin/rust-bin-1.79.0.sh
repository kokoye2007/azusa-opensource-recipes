#!/bin/sh
source "../../common/init.sh"

# aarch64
#get https://static.rust-lang.org/dist/rust-${PV}-i686-unknown-linux-gnu.tar.xz
get https://static.rust-lang.org/dist/rust-"${PV}"-x86_64-unknown-linux-gnu.tar.xz
envcheck

cd "${S}" || exit

INSTALL_OPTS=(
	--destdir="${D}"
	--prefix="/pkg/main/${PKG}.core.${PVRF}"
	--sysconfdir="${D}/pkg/main/${PKG}.core.${PVRF}/etc"
	--bindir="${D}/pkg/main/${PKG}.core.${PVRF}/bin"
	--libdir="${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
	--datadir="${D}/pkg/main/${PKG}.data.${PVRF}/share"
	--mandir="${D}/pkg/main/${PKG}.doc.${PVRF}/man"
	--docdir="${D}/pkg/main/${PKG}.doc.${PVRF}"
	--disable-ldconfig
	--disable-verify
)

./install.sh "${INSTALL_OPTS[@]}"

# remove uninstall script
rm -f "${D}/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX/rustlib/uninstall.sh"

finalize
