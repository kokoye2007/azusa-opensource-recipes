#!/bin/sh
source "../../common/init.sh"
source ${ROOTDIR}/common/python.sh

get https://home.apache.org/~arfrever/distfiles/${P}.tar.xz
acheck

cd "${P}"

PYTHON_RESTRICT="3.10"

pythonsetup
archive
