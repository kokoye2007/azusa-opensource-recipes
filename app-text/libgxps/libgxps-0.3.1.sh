#!/bin/sh
source "../../common/init.sh"

get http://ftp.gnome.org/pub/gnome/sources/libgxps/0.3/${P}.tar.xz

cd "${T}"

importpkg zlib

domeson

finalize
