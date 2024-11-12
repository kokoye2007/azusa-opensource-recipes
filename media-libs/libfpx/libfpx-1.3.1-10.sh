#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.imagemagick.org/pub/ImageMagick/delegates/"${P}".tar.bz2
acheck

cd "${S}" || exit

apatch "$FILESDIR/${PN}-1.2.0.13-export-symbols.patch"

doconf --disable-static LIBS="-lstdc++ -lm"

make
make install DESTDIR="${D}"

finalize
