#!/bin/sh
source "../../common/init.sh"

get https://github.com/KhronosGroup/OpenCL-Headers/archive/refs/tags/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

docmake

finalize
