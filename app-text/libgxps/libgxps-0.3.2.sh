#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/libgxps/${PV%.*}/${P}.tar.xz
acheck

cd "${T}"

importpkg zlib

domeson

finalize
