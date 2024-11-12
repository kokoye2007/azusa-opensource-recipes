#!/bin/sh
source "../../common/init.sh"

get https://releases.pagure.org/xmlto/"${P}".tar.bz2
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
