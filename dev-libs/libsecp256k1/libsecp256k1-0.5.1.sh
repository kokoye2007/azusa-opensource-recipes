#!/bin/sh
source "../../common/init.sh"

get https://github.com/bitcoin-core/secp256k1/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${S}"

aautoreconf

cd "${T}"

doconf --disable-benchmark

make
make install DESTDIR="${D}"

finalize
