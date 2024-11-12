#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/"${PN}"/archive/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

docmake -DSHADERC_SKIP_TESTS="true" -DSHADERC_ENABLE_WERROR_COMPILE="false"

finalize
