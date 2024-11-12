#!/bin/sh
source "../../common/init.sh"

get http://files.libburnia-project.org/releases/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg dev-libs/libburn dev-libs/libisofs

doconf

make
make install DESTDIR="${D}"

finalize
