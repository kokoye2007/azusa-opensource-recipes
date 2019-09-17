#!/bin/sh
source "../../common/init.sh"

get https://github.com/intel/intel-vaapi-driver/releases/download/${PV}/intel-vaapi-driver-${PV}.tar.bz2

cd "${T}"

doconf

make
make install DESTDIR="${D}"

# rename folder
mv "${D}/pkg/main/x11-libs.libva.libs".* "${D}/pkg/main/${PKG}.libs.${PVR}"

finalize
