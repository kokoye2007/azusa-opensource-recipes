#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/nsync/archive/"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

docmake

finalize
