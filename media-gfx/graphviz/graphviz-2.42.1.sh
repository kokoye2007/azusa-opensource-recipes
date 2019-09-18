#!/bin/sh
source "../../common/init.sh"

get https://www2.graphviz.org/Packages/stable/portable_source/${P}.tar.gz

cd "${P}"

sed -i '/LIBPOSTFIX="64"/s/64//' configure.ac

autoreconf

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
