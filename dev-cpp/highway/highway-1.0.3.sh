#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/highway/archive/refs/tags/"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

docmake -DHWY_SYSTEM_GTEST=ON -DBUILD_TESTING=OFF

finalize
