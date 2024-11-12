#!/bin/sh
source "../../common/init.sh"

get https://kohei.us/files/ixion/src/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg dev-libs/boost

doconf --enable-python --disable-static --enable-threads

make
make install DESTDIR="${D}"

finalize
