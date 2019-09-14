#!/bin/sh
source "../../common/init.sh"

get https://storage.googleapis.com/downloads.webmproject.org/releases/webp/${P}.tar.gz

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
