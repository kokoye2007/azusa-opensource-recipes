#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/vaapi/releases/libva-vdpau-driver/"${P}".tar.bz2
acheck

cd "${S}" || exit

PATCHES=(
    "${FILESDIR}"/${P}-glext-missing-definition.patch
    "${FILESDIR}"/${P}-VAEncH264VUIBufferType.patch
    "${FILESDIR}"/${P}-libvdpau-0.8.patch
    "${FILESDIR}"/${P}-sigfpe-crash.patch
    "${FILESDIR}"/${P}-include-linux-videodev2.h.patch
)
apatch "${PATCHES[@]}"

cd "${T}" || exit

importpkg X vdpau media-libs/mesa

doconf --enable-glx

make
make install DESTDIR="${D}"

finalize
