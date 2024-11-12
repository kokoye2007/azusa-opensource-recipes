#!/bin/sh
source "../../common/init.sh"

get https://github.com/intel/intel-vaapi-driver/releases/download/"${PV}"/intel-vaapi-driver-"${PV}".tar.bz2
acheck

cd "${T}" || exit

importpkg X

doconf

make
make install DESTDIR="${D}"

# rename folder
mv -v "${D}/pkg/main/x11-libs.libva.libs".* "${D}/pkg/main/${PKG}.libs.${PVRF}"

finalize
