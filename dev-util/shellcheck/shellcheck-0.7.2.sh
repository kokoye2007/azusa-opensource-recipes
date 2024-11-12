#!/bin/sh
source "../../common/init.sh"

MY_PN="ShellCheck"
MY_P="${MY_PN}-${PV}"
get https://hackage.haskell.org/package/"${MY_P}"/"${MY_P}".tar.gz
acheck

cd "${T}" || exit

importpkg zlib

doconf

make
make install DESTDIR="${D}"

finalize
