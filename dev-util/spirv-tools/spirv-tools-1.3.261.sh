#!/bin/sh
source "../../common/init.sh"

EGIT_COMMIT="sdk-${PV}.0"
get https://github.com/KhronosGroup/${MY_PN}/archive/${EGIT_COMMIT}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

docmake -DSPIRV-Headers_SOURCE_DIR=/pkg/main/dev-util.spirv-headers.dev -DSPIRV_WERROR=OFF -DSPIRV_TOOLS_BUILD_STATIC=OFF

finalize
