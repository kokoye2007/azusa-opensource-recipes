#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/"${PN}"/"${PV%.*}"/"${P}".tar.xz
acheck

importpkg zlib

cd "${T}" || exit

# TODO fix docbook_docs building (xml-to)
domeson

finalize
