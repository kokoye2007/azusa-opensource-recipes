#!/bin/sh
source "../../common/init.sh"

CommitId=c7aeac02222978e7673ee5381bfcaa6b60d5d69c

get https://github.com/pytorch/"${PN}"/archive/${CommitId}.tar.gz "${P}.tar.gz"
acheck

S="${S}/libkineto"

cd "${S}" || exit

docmake

finalize
