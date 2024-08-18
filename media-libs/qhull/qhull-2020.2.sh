#!/bin/sh
source "../../common/init.sh"

get https://github.com/qhull/qhull/archive/${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

docmake

finalize
