#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnome.org/pub/gnome/sources/${PN}/${PV%.*}/${P}.tar.xz
acheck

cd "${T}"

importpkg x11-libs/cairo

# TODO fix man (xslt)
domeson -Dcolord=enabled -Dbroadway_backend=true

finalize
