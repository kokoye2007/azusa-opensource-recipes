#!/bin/sh
source "../../common/init.sh"

get https://github.com/LibVNC/x11vnc/archive/${PV}.tar.gz ${P}.tar.gz
acheck

cd "$S"

PATCHES=(
	"${FILESDIR}"/${P}-crypto.patch # https://github.com/LibVNC/x11vnc/issues/86
	"${FILESDIR}"/${P}-anonymous-ssl.patch # https://github.com/LibVNC/x11vnc/pull/85
	"${FILESDIR}"/${P}-libressl.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

apatch "${PATCHES[@]}"
aautoreconf

cd "${T}"

importpkg x11-base/xorg-proto x11-libs/libX11 x11-libs/libXtst x11-libs/libXext x11-libs/libXcursor x11-libs/libXinerama x11-libs/libXrandr x11-libs/libXfixes x11-libs/libXdamage x11-libs/libXcomposite

export CFLAGS="${CPPFLAGS} -O2"

doconf

make
make install DESTDIR="${D}"

finalize
