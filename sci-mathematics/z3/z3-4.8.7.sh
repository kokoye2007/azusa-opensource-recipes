#!/bin/sh
source "../../common/init.sh"

get https://github.com/Z3Prover/z3/archive/${P}.tar.gz
acheck

importpkg gmp

cd */

doconflight --gmp

cd build
make -j6
make install DESTDIR="${D}"

finalize
