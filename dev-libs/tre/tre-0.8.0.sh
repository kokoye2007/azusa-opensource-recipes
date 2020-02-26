#!/bin/sh
source "../../common/init.sh"

get https://laurikari.net/tre/${P}.tar.bz2
acheck

cd "${T}"

doconf --enable-agrep --enable-system-abi --enable-nls

make
make install DESTDIR="${D}"

finalize
