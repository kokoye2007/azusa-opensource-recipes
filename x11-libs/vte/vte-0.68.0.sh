#!/bin/sh
source "../../common/init.sh"

get http://ftp.nara.wide.ad.jp/pub/X11/GNOME/sources/vte/${PV:0:4}/${P}.tar.xz
acheck

cd "${T}"

importpkg zlib x11-libs/cairo

domeson -Da11y=true -D_systemd=false -Dvapi=true -Dgtk3=true -Dgtk4=false -Dglade=true -Dfribidi=true -Dgir=true

finalize
