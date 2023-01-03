#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/brotli/archive/v${PV}.tar.gz
acheck

cd "${T}"

docmake

finalize
