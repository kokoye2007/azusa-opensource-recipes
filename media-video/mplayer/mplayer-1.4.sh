#!/bin/sh
source "../../common/init.sh"

get http://www.mplayerhq.hu/MPlayer/releases/MPlayer-${PV}.tar.xz
acheck

cd "MPlayer-${PV}"

# fix attempts to access ffmpeg includes
rm -fr ffmpeg
ln -snfT /pkg/main/media-video.ffmpeg.dev/include ffmpeg

importpkg media-video/ffmpeg

doconflight --confdir=/etc/mplayer --disable-svga --disable-svgalib_helper --disable-ass-internal --disable-arts --disable-directfb --disable-kai --disable-libopus --disable-libilbc --disable-xvmc --enable-networking --disable-gui --disable-vesa --disable-ffmpeg_a --extra-cflags="$CPPFLAGS"

make
make install DESTDIR="${D}"

finalize
