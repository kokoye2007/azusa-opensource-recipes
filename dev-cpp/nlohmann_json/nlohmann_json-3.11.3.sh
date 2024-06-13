#!/bin/sh
source "../../common/init.sh"

get https://github.com/nlohmann/json/archive/v${PV}.tar.gz ${P}.tar.gz

acheck

cd "${T}"

docmake -DJSON_MultipleHeaders=ON -DJSON_BuildTests=OFF

finalize
