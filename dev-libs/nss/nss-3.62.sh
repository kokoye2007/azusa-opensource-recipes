#!/bin/sh
source "../../common/init.sh"


get https://ftp.mozilla.org/pub/security/nss/releases/NSS_3_62_RTM/src/${P}.tar.gz
acheck

cd "${P}/${PN}"

importpkg nspr sqlite3 zlib

./build.sh --opt --system-nspr --system-sqlite

cd ../dist

mkdir Release/bin-test
mv Release/bin/*_gtest Release/bin-test
rm Release/lib/*.TOC
mkdir -p "${D}/pkg/main/"
mv Release "${D}/pkg/main/${PKG}.core.${PVRF}"
mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}"
mv -T public "${D}/pkg/main/${PKG}.dev.${PVRF}/include"
mv -T private "${D}/pkg/main/${PKG}.dev.${PVRF}/include/nss/private"

# build NSS pkgconfig ourselves since nss doesn't know where it gets installed

mkdir "${D}/pkg/main/${PKG}.dev.${PVRF}/pkgconfig"

cat >"${D}/pkg/main/${PKG}.dev.${PVRF}/pkgconfig/nss.pc" <<EOF
prefix=/pkg/main/${PKG}.core.${PVRF}
exec_prefix=\${prefix}
libdir=\${prefix}/lib$LIB_SUFFIX
includedir=/pkg/main/${PKG}.dev.${PVRF}/include/nss

Name: NSS
Description: Network Security Services
Version: ${PV}
Requires: nspr >= 4.8
Libs: -L\${libdir} -lssl3 -lsmime3 -lnss3 -lnssutil3
Cflags: -I\${includedir}
EOF

cat >"${D}/pkg/main/${PKG}.dev.${PVRF}/pkgconfig/nss-softokn.pc" <<EOF
prefix=/pkg/main/${PKG}.core.${PVRF}
exec_prefix=\${prefix}
libdir=\${prefix}/lib$LIB_SUFFIX
includedir=/pkg/main/${PKG}.dev.${PVRF}/include/nss

Name: NSS
Description: Network Security Services
Version: ${PV}
Requires: nspr >= 4.8
Libs: -L\${libdir} -lfreebl -lssl3 -lsmime3 -lnss3 -lnssutil3
Cflags: -I\${includedir}/private -I\${includedir}
EOF

finalize
