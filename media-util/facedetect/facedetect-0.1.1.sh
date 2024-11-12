#!/bin/sh
source "../../common/init.sh"

get https://github.com/AzusaOS/facedetect/archive/refs/tags/v0.1.1.tar.gz "$P".tar.gz
acheck

cd "${S}" || exit

mkdir -p "${D}/pkg/main/${PKG}.core.${PVRF}/bin"
cp -a facedetect "${D}/pkg/main/${PKG}.core.${PVRF}/bin"

finalize
