#!/bin/sh
source "../../common/init.sh"

get https://git.kernel.org/pub/scm/libs/libcap/libcap.git/snapshot/"${P}".tar.gz
acheck

cd "${P}" || exit

sed -i '/install.*STALIBNAME/d' libcap/Makefile

# configure & build
make
make install RAISE_SETFCAP=no prefix="${D}/pkg/main/${PKG}.core.${PVRF}"

cd "${D}" || exit

rm -fr "pkg/main/${PKG}.core.${PVRF}/lib$LIB_SUFFIX/pkgconfig"

mkdir -p "pkg/main/${PKG}.dev.${PVRF}/pkgconfig"
cat >"pkg/main/${PKG}.dev.${PVRF}/pkgconfig/libcap.pc" <<EOF
prefix=/pkg/main/${PKG}.core.${PVRF}
exec_prefix=
libdir=/pkg/main/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX
includedir=/pkg/main/${PKG}.dev.${PVRF}/include

Name: libcap
Description: libcap
Version: $PV
Libs: -L\${libdir} -lcap
Libs.private:
Cflags: -I\${includedir}
EOF

finalize
