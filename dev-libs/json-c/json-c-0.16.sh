#!/bin/sh
source "../../common/init.sh"

get https://s3.amazonaws.com/json-c_releases/releases/${P}.tar.gz
acheck

cd "${T}"

docmake -DDISABLE_EXTRA_LIBS=ON -DDISABLE_WERROR=ON -DENABLE_RDRAND=ON -DENABLE_THREADING=ON

finalize
