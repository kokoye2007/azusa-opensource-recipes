#!/bin/sh
source "../../common/init.sh"

get https://github.com/redis/"${PN}"/archive/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

docmake

finalize
