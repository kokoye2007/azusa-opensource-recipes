#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/xine/${P}.tar.xz
acheck

cd "${P}"

sed -e 's|wand/magick_wand.h|MagickWand/MagickWand.h|' \
    -i src/video_dec/image.c

sed -e 's/\(xcb-shape >= 1.0\)/xcb \1/' \
    -i m4/video_out.m4

cd "${T}"

importpkg zlib ncurses x11 xext xv sys-libs/gpm x11-libs/libXinerama

doconf --disable-vcd --with-external-dvdnav

make
make install DESTDIR="${D}"

finalize
