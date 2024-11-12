#!/bin/sh
source "../../common/init.sh"

get https://libisl.sourceforge.io/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg gmp

# configure & build
doconf 

make
make install DESTDIR="${D}"

finalize
