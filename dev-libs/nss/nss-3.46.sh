#!/bin/sh
source "../../common/init.sh"


get https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_46_RTM/src/${P}.tar.gz

cd "${P}/${PN}"

./build.sh --opt --system-nspr --system-sqlite

cd ../dist

mkdir Release/bin-test
mv Release/bin/*_gtest Release/bin-test
mkdir -p "${D}/pkg/main/"
mv Release "${D}/pkg/main/${PKG}.core.${PVR}"
mkdir -p "${D}/pkg/main/${PKG}.dev.${PVR}"
mv public "${D}/pkg/main/${PKG}.dev.${PVR}/include"
mv private "${D}/pkg/main/${PKG}.dev.${PVR}/private"

finalize
