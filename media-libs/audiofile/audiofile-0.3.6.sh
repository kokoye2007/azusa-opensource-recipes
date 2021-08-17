#!/bin/sh
source "../../common/init.sh"

get https://audiofile.68k.org/${P}.tar.gz
acheck

cd "${S}"

PATCHES=(
    "${FILESDIR}"/${PN}-0.3.6-gcc6-build-fixes.patch
    "${FILESDIR}"/${PN}-0.3.6-CVE-2015-7747.patch
    "${FILESDIR}"/${PN}-0.3.6-mingw32.patch
    "${FILESDIR}"/${PN}-0.3.6-CVE-2017-68xx.patch
    "${FILESDIR}"/${PN}-0.3.6-CVE-2018-13440-CVE-2018-17095.patch
)

apatch "${PATCHES[@]}"

cd "${T}"

importpkg alsa

doconf

make
make install DESTDIR="${D}"

finalize
