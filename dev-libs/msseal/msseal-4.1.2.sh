#!/bin/sh
source "../../common/init.sh"

get https://github.com/microsoft/SEAL/archive/refs/tags/v${PV}.tar.gz "${P}.tar.gz"
acheck

cd "${T}"

importpkg zlib dev-libs/msgsl

# TODO make seal take ZLIB ans MSGSL from the system
docmake -DSEAL_USE_ZLIB=OFF -DSEAL_USE_MSGSL=OFF -DSEAL_USE_ZSTD=OFF

finalize
