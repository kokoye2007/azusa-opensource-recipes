#!/bin/sh
source "../../common/init.sh"

get http://downloads.xiph.org/releases/speex/${P}.tar.gz
acheck

cd "${S}"

apatch "$FILESDIR/speex-1.2.0-configure.patch"

cd "${T}"

# TODO cpu flags
# --enable-sse
# --disable-fixed-point --enable-fixed-point
# --disable-arm4-asm --disable-arm5e-asm --enable-arm5e-asm --enable-arm4-asm
doconf --enable-vbr --with-speexdsp --enable-binaries

make
make install DESTDIR="${D}"

finalize
