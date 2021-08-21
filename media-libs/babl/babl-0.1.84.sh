#!/bin/sh
source "../../common/init.sh"

get https://download.gimp.org/pub/babl/0.1/${P}.tar.xz
acheck

cd "${T}"

importpkg lcms2

domeson

ninja
DESTDIR="${D}" ninja install

finalize
