#!/bin/sh
source "../../common/init.sh"
inherit python

PYTHON_RESTRICT="$PYTHON_LATEST"

get https://launchpad.net/"${PN}"/"${PV%.*}"/"${PV}"/+download/"${P}".tar.gz
acheck

cd "${S}" || exit

pythonsetup

finalize
