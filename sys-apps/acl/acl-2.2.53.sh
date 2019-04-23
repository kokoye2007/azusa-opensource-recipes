#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.nongnu.org/releases/acl/${P}.tar.gz

echo "Compiling ${P} ..."
cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
