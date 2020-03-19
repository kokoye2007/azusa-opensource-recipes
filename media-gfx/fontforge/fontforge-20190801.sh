#!/bin/sh
source "../../common/init.sh"

get https://github.com/fontforge/fontforge/releases/download/${PV}/${P}.tar.gz
acheck

cd "${T}"

importpkg libpng libjpeg media-libs/tiff media-libs/libspiro libuninameslist x11-base/xorg-proto x11-libs/libX11 x11-libs/gtk+ sys-libs/readline x11-libs/cairo media-libs/giflib

export CC="gcc ${CPPFLAGS}"

doconf --disable-static --disable-python-scripting

make -j"$NPROC"
make install DESTDIR="${D}"

finalize
