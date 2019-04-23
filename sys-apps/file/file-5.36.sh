#!/bin/sh
source "../../common/init.sh"

get ftp://ftp.astron.com/pub/file/${P}.tar.gz

cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
