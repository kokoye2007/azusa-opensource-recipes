#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/leveldb/archive/"${PV}".tar.gz
acheck

cd "${T}" || exit

docmake -DLEVELDB_BUILD_TESTS=NO

finalize
