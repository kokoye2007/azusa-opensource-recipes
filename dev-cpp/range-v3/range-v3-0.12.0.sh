#!/bin/sh
source "../../common/init.sh"

get https://github.com/ericniebler/${PN}/archive/${PV}.tar.gz "${P}.tar.gz"
cd "${S}"
apatch $FILESDIR/${PV}-*.patch
acheck

cd "${T}"

docmake -DRANGES_BUILD_CALENDAR_EXAMPLE=OFF -DRANGES_NATIVE=OFF -DRANGES_DEBUG_INFO=OFF -DRANGES_NATIVE=OFF -DRANGES_ENABLE_WERROR=OFF -DRANGES_VERBOSE_BUILD=ON -DRANGE_V3_EXAMPLES=OFF -DRANGE_V3_PERF=OFF -DRANGE_V3_DOCS=OFF -DRANGE_V3_HEADER_CHECKS=OFF -DRANGE_V3_TESTS=OFF

finalize
