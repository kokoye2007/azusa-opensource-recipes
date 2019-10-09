#!/bin/sh
source "../../common/init.sh"

get https://mkvtoolnix.download/sources/${P}.tar.xz
acheck

cd "${T}"

importpkg ogg vorbis dev-libs/boost

# TODO use qt
# TODO requires docbook xsl file
CC=g++ doconf --with-words=little --disable-qt --with-boost=/pkg/main/dev-libs.boost.core

make
make install DESTDIR="${D}"

finalize
