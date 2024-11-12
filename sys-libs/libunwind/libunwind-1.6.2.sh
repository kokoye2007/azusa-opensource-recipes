#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.nongnu.org/releases/"${PN}"/"${P}".tar.gz
acheck

echo "Compiling ${P} ..."
cd "${T}" || exit

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
