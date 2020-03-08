#!/bin/sh
source "../../common/init.sh"

get https://mkvtoolnix.download/sources/${P}.tar.xz
acheck

cd "${P}"

importpkg ogg vorbis dev-libs/boost zlib

for DOCBOOK in /pkg/main/app-text.docbook-xsl-nons-stylesheets.sgml/docbook/xsl-stylesheets-nons-*; do
	:
done

# TODO use qt
CC=g++ doconf --disable-update-check --disable-optimization --with-gettext --with-words=little --disable-qt --with-boost=/pkg/main/dev-libs.boost.core --with-docbook_xsl_root="$DOCBOOK"

rake
DESTDIR="${D}" rake install

finalize
