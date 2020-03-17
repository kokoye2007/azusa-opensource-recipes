#!/bin/sh
source "../../common/init.sh"

get https://github.com/wolfSSL/wolfssl/archive/v${PV}-stable.tar.gz ${P}-stable.tar.gz
acheck

cd "${S}"

aautoreconf

cd "${T}"

doconf --enable-all --enable-distro --disable-static --enable-ecccustcurves=all

make
make install DESTDIR="${D}"

finalize
