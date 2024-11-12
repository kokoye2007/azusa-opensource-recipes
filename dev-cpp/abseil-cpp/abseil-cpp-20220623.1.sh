#!/bin/sh
source "../../common/init.sh"

get https://github.com/abseil/abseil-cpp/archive/"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

docmake -DABSL_ENABLE_INSTALL=TRUE -DCMAKE_CXX_STANDARD=17 -DABSL_PROPAGATE_CXX_STD=TRUE

finalize
