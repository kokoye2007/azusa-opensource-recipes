#!/bin/sh
source "../../common/init.sh"

MY_PN="${PN}-c"
MY_P="${MY_PN}-${PV}"
get https://github.com/"${PN}"/"${PN}"-c/releases/download/c-"${PV}"/"${MY_P}".tar.gz
acheck

cd "${T}" || exit

docmake -DMSGPACK_BUILD_EXAMPLES=OFF -DMSGPACK_BUILD_TESTS=OFF

finalize
