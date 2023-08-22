#!/bin/sh
source "../../common/init.sh"

get https://github.com/xtensor-stack/xsimd/archive/refs/tags/${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

docmake

finalize
