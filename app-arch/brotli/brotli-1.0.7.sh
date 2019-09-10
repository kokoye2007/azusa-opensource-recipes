#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/brotli/archive/v${PV}.tar.gz

cd "${P}"

rm configure
cp configure-cmake configure

cd "${T}"

doconf

make
make install DESTDIR="${D}"

finalize
