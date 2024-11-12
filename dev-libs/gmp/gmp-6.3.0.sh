#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/gmp/"${P}".tar.xz
acheck

cd "${T}" || exit

# configure & build
doconf --enable-cxx --disable-static

make
make install DESTDIR="${D}"

cd "${D}" || exit

mv pkg/main/"${PKG}".core."${PVRF}"/include/gmp.h pkg/main/"${PKG}".dev."${PVRF}"/include/
rmdir pkg/main/"${PKG}".core."${PVRF}"/include

mkdir -p pkg/main/"${PKG}".doc."${PVRF}"
mv pkg/main/"${PKG}".core."${PVRF}"/share/info pkg/main/"${PKG}".doc."${PVRF}"
rmdir pkg/main/"${PKG}".core."${PVRF}"/share
rmdir pkg/main/"${PKG}".core."${PVRF}"

finalize
