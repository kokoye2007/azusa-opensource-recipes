#!/bin/sh
source "../../common/init.sh"

get https://github.com/JuliaStrings/utf8proc/archive/refs/tags/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

docmake

finalize
