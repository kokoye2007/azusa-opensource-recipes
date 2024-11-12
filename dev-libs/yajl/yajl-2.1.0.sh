#!/bin/sh
source "../../common/init.sh"

get https://github.com/lloyd/yajl/tarball/"${PV}" "${P}".tar.gz
acheck

cd "${T}" || exit

docmake

make
make install DESTDIR="${D}"

finalize
