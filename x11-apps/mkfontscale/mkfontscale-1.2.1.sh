#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/pub/individual/app/"${P}".tar.bz2
acheck

cd "${T}" || exit

importpkg zlib

doconf --localstatedir=/var

make
make install DESTDIR="${D}"

finalize
