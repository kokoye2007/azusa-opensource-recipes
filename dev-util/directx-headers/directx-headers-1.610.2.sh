#!/bin/sh
source "../../common/init.sh"

MY_PN=DirectX-Headers
get https://github.com/microsoft/${MY_PN}/archive/refs/tags/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${T}" || exit

domeson -Dbuild-test=false

finalize
