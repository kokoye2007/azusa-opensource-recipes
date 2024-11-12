#!/bin/sh
source "../../common/init.sh"

get https://download.osgeo.org/libtiff/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
