#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/rest/${PV%.*}/${P}.tar.xz
acheck

cd "${T}"

export XDG_DATA_DIRS="/usr/share:/pkg/main/dev-libs.gobject-introspection.core/share:/pkg/main/net-libs.libsoup.core/share"

domeson

finalize
