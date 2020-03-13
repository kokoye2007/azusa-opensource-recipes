#!/bin/sh
source "../../common/init.sh"

get https://mupdf.com/downloads/archive/${P}-source.tar.xz
acheck

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
