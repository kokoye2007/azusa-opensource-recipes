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

docmake -DUSE_PAM=ON -DUSE_CONSOLEKIT=ON

make
make install DESTDIR="${D}"

finalize
