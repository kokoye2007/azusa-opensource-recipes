#!/bin/sh
source "../../common/init.sh"

get https://github.com/martijnberger/clew/archive/refs/tags/"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

docmake

finalize
