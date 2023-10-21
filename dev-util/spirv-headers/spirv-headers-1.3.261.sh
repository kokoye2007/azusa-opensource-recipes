#!/bin/sh
source "../../common/init.sh"

EGIT_COMMIT="sdk-${PV}"
get https://github.com/KhronosGroup/SPIRV-Headers/archive/${EGIT_COMMIT}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

docmake

finalize
