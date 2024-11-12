#!/bin/sh
source "../../common/init.sh"

get http://download.savannah.nongnu.org/releases/attr/"${P}".tar.gz
acheck

echo "Compiling ${P} ..."
cd "${T}" || exit

# configure & build
doconf

make
make install DESTDIR="${D}"

cd "${D}" || exit
mv "etc" "pkg/main/${PKG}.core.${PVRF}"

finalize
