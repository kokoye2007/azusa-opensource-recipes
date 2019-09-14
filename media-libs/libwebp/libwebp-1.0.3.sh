#!/bin/sh
source "../../common/init.sh"

get https://storage.googleapis.com/downloads.webmproject.org/releases/webp/${P}.tar.gz

cd "${T}"

doconf --enable-everything

make
make install DESTDIR="${D}"

finalize
