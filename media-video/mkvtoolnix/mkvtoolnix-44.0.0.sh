#!/bin/sh
source "../../common/init.sh"

get https://mkvtoolnix.download/sources/${P}.tar.xz
acheck

cd "${P}"

importpkg ogg vorbis dev-libs/boost zlib

for DOCBOOK in /pkg/main/app-text.docbook-xsl-nons-stylesheets.sgml/docbook/xsl-stylesheets-nons-*; do
	:
done

export CFLAGS="${CPPFLAGS} -O2"

# TODO fix:
#   * FLAC audio
#   * libMagic file type detection

doconf --disable-update-check --disable-optimization --with-gettext --with-words=little --with-boost=/pkg/main/dev-libs.boost.core --with-docbook_xsl_root="$DOCBOOK" || /bin/bash -i

rake
DESTDIR="${D}" rake install

finalize
