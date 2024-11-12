#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnome.org/pub/gnome/sources/"${PN}"/"${PV%.*}"/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg x11-libs/cairo

# TODO fix man (xslt)
domeson -Dcolord=enabled

finalize
