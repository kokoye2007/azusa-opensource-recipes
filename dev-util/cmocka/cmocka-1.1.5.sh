#!/bin/sh
source "../../common/init.sh"

get https://cmocka.org/files/"${PV%.*}"/"${P}".tar.xz
acheck

cd "${T}" || exit

docmake

make
make install DESTDIR="${D}"

finalize
