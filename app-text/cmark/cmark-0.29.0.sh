#!/bin/sh
source "../../common/init.sh"

get https://github.com/commonmark/cmark/archive/${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

docmake -DCMARK_LIB_FUZZER=OFF -DCMARK_SHARED=ON -DCMARK_STATIC=OFF -DCMARK_TESTS=ON

finalize
