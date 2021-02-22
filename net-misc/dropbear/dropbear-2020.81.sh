#!/bin/sh
source "../../common/init.sh"

get https://matt.ucc.asn.au/dropbear/releases/${P}.tar.bz2
acheck

cd "${T}"

doconf --enable-static --enable-bundled-libtom --disable-zlib CC="musl-gcc"

make
make install DESTDIR="${D}"

finalize
