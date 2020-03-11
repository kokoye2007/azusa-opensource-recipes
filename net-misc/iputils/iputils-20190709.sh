#!/bin/sh
source "../../common/init.sh"

get https://github.com/iputils/iputils/archive/s${PV}.tar.gz ${P}.tar.gz
acheck

cd "${T}"

domeson

finalize
