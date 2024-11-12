#!/bin/sh
source "../../common/init.sh"

get https://github.com/KhronosGroup/"${MY_PN}"/archive/sdk-"${PV}".0.tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

docmake

finalize
