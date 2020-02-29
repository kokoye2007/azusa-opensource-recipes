#!/bin/sh
source "../../common/init.sh"

get https://git.kernel.org/pub/scm/libs/libcap/libcap.git/snapshot/${P}.tar.gz
acheck

sed -i '/install.*STALIBNAME/d' ${P}/libcap/Makefile

cd ${P}

# configure & build
make
make install RAISE_SETFCAP=no prefix="${D}/pkg/main/${PKG}.core.${PVR}"

cd "${D}"

rm -fr "pkg/main/${PKG}.core.${PVR}/lib$LIB_SUFFIX/pkgconfig"

mkdir -p "pkg/main/${PKG}.dev.${PVR}/pkgconfig"
cat >"pkg/main/${PKG}.dev.${PVR}/pkgconfig/libcap.pc" <<EOF
prefix=/pkg/main/${PKG}.core.${PVR}
exec_prefix=
libdir=/pkg/main/${PKG}.libs.${PVR}/lib$LIB_SUFFIX
includedir=/pkg/main/${PKG}.dev.${PVR}/include

Name: libcap
Description: libcap
Version: $PV
Libs: -L\${libdir} -lcap
Libs.private:
Cflags: -I\${includedir}
EOF

finalize
