#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/leveldb/archive/${PV}.tar.gz
acheck

cd "${T}"

docmake -DLEVELDB_BUILD_TESTS=NO

finalize
