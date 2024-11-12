#!/bin/sh
source "../../common/init.sh"

get https://github.com/lu-zero/cargo-c/archive/refs/tags/v"${PV}".tar.gz
envcheck

cd "${S}" || exit

export LIBSSH2_SYS_USE_PKG_CONFIG=1
export LIBGIT2_SYS_USE_PKG_CONFIG=1
export PKG_CONFIG_ALLOW_CROSS=1

# cargo does not actually use pkgconfig, help it
importpkg net-libs/libssh2

cargo build --release
mkdir -pv "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
for foo in capi cbuild cinstall ctest; do
	mv -v target/release/cargo-$foo "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
done

finalize
