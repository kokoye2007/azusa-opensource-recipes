#!/bin/sh
source "../../common/init.sh"

get https://github.com/wdas/ptex/archive/v${PV}.tar.gz
acheck

cd "${S}"

echo "$PV" >version

cd "${T}"

docmake -DPTEX_BUILD_STATIC_LIBS=ON

finalize
