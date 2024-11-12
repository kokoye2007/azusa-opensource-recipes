#!/bin/sh
source "../../common/init.sh"

get https://ftp.gnu.org/gnu/m4/"${P}".tar.xz
acheck

echo "Compiling ${P} ..."
cd "${T}" || exit

# configure & build
doconf

make
make install DESTDIR="${D}"

finalize
