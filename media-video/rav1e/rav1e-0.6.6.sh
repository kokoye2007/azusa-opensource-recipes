#!/bin/sh
source "../../common/init.sh"

get https://github.com/xiph/rav1e/archive/v${PV}.tar.gz
envcheck

cd "${S}"

importpkg zlib

cargo build --release
cargo cbuild --release --target-dir="capi" --prefix="/pkg/main/${PKG}.core.${PVRF}" --libdir="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX"
cargo cinstall --release --target-dir="capi" --prefix="/pkg/main/${PKG}.core.${PVRF}" --libdir="/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX" --destdir="${D}"


finalize
