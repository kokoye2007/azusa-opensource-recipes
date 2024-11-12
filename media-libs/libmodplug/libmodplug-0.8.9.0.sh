#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/project/modplug-xmms/libmodplug/"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

# override prefix to solve pkg-config issue
doconf --prefix="/pkg/main/${PKG}.dev.${PVRF}"

make
make install DESTDIR="${D}"

finalize
