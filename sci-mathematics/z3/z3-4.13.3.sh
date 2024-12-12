#!/bin/sh
source "../../common/init.sh"

get https://github.com/Z3Prover/z3/archive/${P}.tar.gz
acheck

importpkg gmp

cd "${T}"

docmake -DCMAKE_SHARED_LINKER_FLAGS="-static-libstdc++ -static-libgcc"

finalize
