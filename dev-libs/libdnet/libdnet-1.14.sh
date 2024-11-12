#!/bin/sh
source "../../common/init.sh"

get https://github.com/ofalk/"${PN}"/archive/"${P}".tar.gz
acheck

cd "${T}" || exit

doconflight

make
make install DESTDIR="${D}"

finalize
