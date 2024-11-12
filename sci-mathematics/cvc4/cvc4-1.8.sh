#!/bin/sh
source "../../common/init.sh"

get https://github.com/CVC4/CVC4-archived/archive/refs/tags/"${PV}".tar.gz "${P}.tar.gz"
acheck

cd "${T}" || exit

importpkg gmp sys-libs/readline

# -DANTLR_BINARY=/usr/bin/antlr3
docmake -DCMAKE_BUILD_TYPE=Production -DENABLE_GPL=ON -DUSE_CLN=ON -DUSE_READLINE=OFF -DENABLE_STATISTICS=ON -DENABLE_PROOFS=ON

finalize
