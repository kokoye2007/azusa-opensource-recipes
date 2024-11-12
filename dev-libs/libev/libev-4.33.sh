#!/bin/sh
source "../../common/init.sh"

get http://dist.schmorp.de/"${PN}"/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf --disable-static

make
make install DESTDIR="${D}"

finalize
