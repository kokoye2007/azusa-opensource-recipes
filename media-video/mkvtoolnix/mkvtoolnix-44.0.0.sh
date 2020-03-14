#!/bin/sh
source "../../common/init.sh"

get https://mkvtoolnix.download/sources/${P}.tar.xz
acheck

cd "${P}"

importpkg ogg vorbis dev-libs/boost zlib

#for DOCBOOK in /pkg/main/app-text.docbook-xsl-nons-stylesheets.sgml/docbook/xsl-stylesheets-nons-*; do
#	:
#done

#export libcmark_CFLAGS="-I/pkg/main/app-text.cmark.dev/include"
#export libcmark_LIBS="-L/pkg/main/app-text.cmark.libs/lib$LIB_SUFFIX -lcmark"
#/pkg/main/app-text.cmark.dev

export CFLAGS="${CPPFLAGS} -O2"

doconf --disable-update-check --disable-optimization --with-gettext --with-words=little --with-boost=/pkg/main/dev-libs.boost.core || /bin/bash -i

rake
DESTDIR="${D}" rake install

finalize
