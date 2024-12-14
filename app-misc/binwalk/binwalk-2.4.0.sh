#!/bin/sh
source "../../common/init.sh"
inherit python

get https://github.com/OSPG/${PN}/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${S}"

pythonsetup

finalize
