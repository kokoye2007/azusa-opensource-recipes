#!/bin/sh
source "../../common/init.sh"

get https://github.com/wolfSSL/wolfssl/archive/v"${PV}"-stable.tar.gz "${P}"-stable.tar.gz
acheck

cd "${S}" || exit

aautoreconf

cd "${T}" || exit

doconf --enable-all --enable-distro --disable-static --enable-ecccustcurves=all

make
make install DESTDIR="${D}"

finalize
