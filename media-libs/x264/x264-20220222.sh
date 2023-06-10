#!/bin/sh
source "../../common/init.sh"

#P=x264-snapshot-${PV}-2245
#get https://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-${PV}-2245.tar.bz2
get https://dev.gentoo.org/~aballier/distfiles/${PN}-0.0.${PV}.tar.bz2
acheck

cd "${T}"

doconf --enable-shared --enable-pic

make
make install DESTDIR="${D}"

finalize
