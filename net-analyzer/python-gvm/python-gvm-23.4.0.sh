#!/bin/sh
source "../../common/init.sh"
inherit python

get https://github.com/greenbone/"${PN}"/archive/v"${PV}".tar.gz "${P}".tar.gz
acheck

cd "${S}" || exit

pythonsetup

finalize
