#!/bin/sh
source "../../common/init.sh"

get https://github.com/silnrsi/graphite/releases/download/"${PV}"/"${P}".tgz

cd "${P}" || exit

sed -i '/cmptest/d' tests/CMakeLists.txt

cd "${T}" || exit

cmake -DCMAKE_INSTALL_PREFIX=/pkg/main/"${PKG}".core."${PVRF}" "${CHPATH}/${P}"

make
make install DESTDIR="${D}"

finalize
