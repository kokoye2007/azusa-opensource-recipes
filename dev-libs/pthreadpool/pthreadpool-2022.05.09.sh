#!/bin/sh
source "../../common/init.sh"
inherit python

CommitId=1787867f6183f056420e532eec640cba25efafea

get https://github.com/Maratyszcza/"${PN}"/archive/${CommitId}.tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

docmake -DPTHREADPOOL_BUILD_BENCHMARKS=OFF -DPTHREADPOOL_BUILD_TESTS=OFF

finalize
