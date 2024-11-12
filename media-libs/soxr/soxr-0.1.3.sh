#!/bin/sh
source "../../common/init.sh"

get https://sourceforge.net/projects/soxr/files/"${P}"-Source.tar.xz
acheck

cd "${T}" || exit

cmake "${CHPATH}/${P}-Source" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/pkg/main/"${PKG}".core."${PVRF}"

make
make install DESTDIR="${D}"

finalize
