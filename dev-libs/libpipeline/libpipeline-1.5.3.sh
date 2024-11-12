#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.nongnu.org/releases/"${PN}"/"${P}".tar.gz
acheck

cd "${T}" || exit

doconf

make
make install DESTDIR="${D}"

finalize
