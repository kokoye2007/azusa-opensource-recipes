#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/libwnck/${PV%.*}/${P}.tar.xz
acheck

importpkg zlib

cd "${T}"

domeson

finalize
