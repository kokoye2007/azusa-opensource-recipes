#!/bin/sh
source "../../common/init.sh"

get https://github.com/oneapi-src/oneTBB/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
acheck

docmake -DTBB_TEST=OFF -DTBB_ENABLE_IPO=OFF -DTBB_STRICT=OFF

finalize
