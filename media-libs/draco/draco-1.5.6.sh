#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/draco/archive/refs/tags/${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

docmake

finalize
