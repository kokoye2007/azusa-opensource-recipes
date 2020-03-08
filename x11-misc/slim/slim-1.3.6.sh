#!/bin/sh
source "../../common/init.sh"

get https://sourceforge.net/projects/slim.berlios/files/${P}.tar.gz
acheck

# patches from gentoo (seems like slim isn't exactly maintained, so a lot of stuff needs fixing)
PATCHES=(
    "${FILESDIR}"/${PN}-1.3.5-arm.patch
    "${FILESDIR}"/${P}-honour-cflags.patch
    "${FILESDIR}"/${P}-libslim-cmake-fixes.patch
    "${FILESDIR}"/${PN}-1.3.5-disable-ck-for-systemd.patch
    "${FILESDIR}"/${P}-strip-systemd-unit-install.patch
    "${FILESDIR}"/${P}-systemd-session.patch
    "${FILESDIR}"/${P}-session-chooser.patch
    "${FILESDIR}"/${P}-fix-slimlock-nopam-v2.patch
    "${FILESDIR}"/${P}-drop-zlib.patch
    "${FILESDIR}"/${P}-freetype.patch
    "${FILESDIR}"/${P}-envcpy-bad-pointer-arithmetic.patch
)

cd "${P}"

apatch "${PATCHES[@]}"

cd "${T}"

importpkg libpng libjpeg zlib sys-libs/pam x11-base/xorg-proto

export CXXFLAGS="${CPPFLAGS} -O2"

CMAKEOPTS=(
	-DUSE_PAM=ON
	-DUSE_CONSOLEKIT=ON
	-DFREETYPE_INCLUDE_DIRS=/pkg/main/media-libs.freetype.dev/include
	-DFREETYPE_LIBRARY=/pkg/main/media-libs.freetype.libs/lib$LIB_SUFFIX
	-DCRYPTO_LIB=/pkg/main/dev-libs.openssl.libs/lib$LIB_SUFFIX/libcrypto.so
	-DM_LIB=/pkg/main/sys-libs.glibc.libs/lib64/libm.so
	-DRT_LIB=/pkg/main/sys-libs.glibc.libs/lib64/librt.so
)

for foo in X11 Xext Xrender Xrandr Xmu Xft; do
	CMAKEOPTS+=("-DX11_${foo}_LIB=/pkg/main/x11-libs.lib${foo}.libs/lib$LIB_SUFFIX/lib${foo}.so")
	CMAKEOPTS+=("-DX11_${foo}_INCLUDE_PATH=/pkg/main/x11-libs.lib${foo}.dev/include")
done

docmake "${CMAKEOPTS[@]}"

make
make install DESTDIR="${D}"

finalize
