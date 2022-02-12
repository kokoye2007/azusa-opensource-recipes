#!/bin/sh
source "../../common/init.sh"

get https://github.com/google/googletest/archive/release-${PV}.tar.gz
acheck

cd "${T}"

CMAKE_ROOT="${CHPATH}/googletest-release-${PV}"
docmake

finalize
