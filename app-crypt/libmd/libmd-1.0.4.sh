#!/bin/sh
source "../../common/init.sh"

get https://archive.hadrons.org/software/libmd/"${P}".tar.xz
acheck

cd "${T}" || exit

importpkg zlib

doconf

make
make install DESTDIR="${D}"

finalize
