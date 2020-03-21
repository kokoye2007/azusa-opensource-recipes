#!/bin/sh
source "../../common/init.sh"
inherit libs

get https://download.sourceforge.net/mad/${P}.tar.gz
acheck

preplib

cd "$S"

PATCHES=(
	"${FILESDIR}"/${P}-cflags.patch
	"${FILESDIR}"/${P}-cflags-O2.patch
	"${FILESDIR}"/${P}-gcc44-mips-h-constraint-removal.patch
	"${FILESDIR}"/${P}-CVE-2017-8372_CVE-2017-8373_CVE-2017-8374.patch
)

apatch "${PATCHES[@]}"

cd "${T}"

doconflight --enable-accuracy --disable-static

make
make install DESTDIR="${D}"

mkdir -p "${D}/main/pkg/${PKG}.dev.${PVRF}/pkgconfig"

cat >"${D}/main/pkg/${PKG}.dev.${PVRF}/pkgconfig/mad.pc" <<EOF
prefix=/main/pkg/${PKG}.dev.${PVRF}
exec_prefix=\${prefix}
libdir=/main/pkg/${PKG}.libs.${PVRF}/lib$LIB_SUFFIX
includedir=\${prefix}/include

Name: mad
Description: MPEG Audio Decoder
Requires:
Version: 0.15.0b
Libs: -L\${libdir} -lmad -lm
Cflags: -I\${includedir}
EOF

finalize
