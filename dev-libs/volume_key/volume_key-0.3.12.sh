#!/bin/sh
source "../../common/init.sh"

#get https://pagure.io/volume_key/archive/${P}/volume_key-${P}.tar.gz
get http://releases.pagure.org/${PN}/${P}.tar.xz
acheck

cd "${T}"

doconf --without-python --with-python3

make
make install DESTDIR="${D}"

finalize
