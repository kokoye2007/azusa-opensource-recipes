#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.nongnu.org/releases/attr/${P}.tar.gz

echo "Compiling ${P} ..."
cd "${T}"

# configure & build
doconf

make
make install DESTDIR="${D}"

cd "${D}"
mv "etc" "pkg/main/${PKG}.core.${PVRF}"

finalize
