#!/bin/sh
source "../../common/init.sh"
inherit python

PYTHON_RESTRICT="$PYTHON_LATEST"

get https://github.com/greenbone/gvm-tools/archive/v${PV}.tar.gz ${P}.tar.gz
acheck

cd "${S}"

pythonsetup

finalize
