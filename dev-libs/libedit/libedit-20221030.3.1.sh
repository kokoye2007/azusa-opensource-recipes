#!/bin/sh
source "../../common/init.sh"

MY_PV=${PV/./-}
MY_P=${PN}-${MY_PV}
get https://thrysoee.dk/editline/"${MY_P}".tar.gz
acheck

cd "${T}" || exit

importpkg tinfo

importpkg zlib

doconf --enable-widec --enable-fast-install

make
make install DESTDIR="${D}"

finalize
