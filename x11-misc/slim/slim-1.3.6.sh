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

CMAKEOPTS=(
	-DUSE_PAM=ON
	-DUSE_CONSOLEKIT=ON
	-DX11_X11_INCLUDE_PATH=/pkg/main/x11-libs.libX11.dev/include
	-DX11_X11_LIB=/pkg/main/x11-libs.libX11.libs/lib$LIB_SUFFIX
	-DFREETYPE_INCLUDE_DIRS=/pkg/main/media-libs.freetype.dev/include
	-DFREETYPE_LIBRARY=/pkg/main/media-libs.freetype.libs/lib$LIB_SUFFIX
	-DJPEG_INCLUDE_DIR=/pkg/main/media-libs.libjpeg-turbo.dev/include
	-DJPEG_LIBRARY=/pkg/main/media-libs.libjpeg-turbo.libs/lib$LIB_SUFFIX
	-DZLIB_INCLUDE_DIR=/pkg/main/sys-libs.zlib.dev/include
	-DZLIB_LIBRARY=/pkg/main/sys-libs.zlib.libs/lib$LIB_SUFFIX
	-DPNG_PNG_INCLUDE_DIR=/pkg/main/media-libs.libpng.dev/include
	-DPNG_LIBRARY=/pkg/main/media-libs.libpng.libs/lib$LIB_SUFFIX
)

docmake "${CMAKEOPTS[@]}"

make
make install DESTDIR="${D}"

finalize
