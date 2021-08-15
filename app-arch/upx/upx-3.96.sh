#!/bin/sh
source "../../common/init.sh"

get https://github.com/upx/upx/releases/download/v${PV}/${P}-src.tar.xz
acheck

cd "${S}"

make all -j"$NPROC"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
cp src/upx.out "${D}/pkg/main/${PKG}.core.${PVRF}/bin/upx"

mkdir -p "${D}/pkg/main/${PKG}.doc.${PVRF}/man/man1"
mkdir -p "${D}/pkg/main/${PKG}.doc.${PVRF}/doc"
cp doc/upx.1 "${D}/pkg/main/${PKG}.doc.${PVRF}/man/man1"
cp doc/upx.html "${D}/pkg/main/${PKG}.doc.${PVRF}/"
cp doc/upx.doc "${D}/pkg/main/${PKG}.doc.${PVRF}/doc"

finalize
