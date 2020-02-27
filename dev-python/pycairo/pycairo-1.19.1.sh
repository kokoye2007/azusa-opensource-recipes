#!/bin/sh
source ../../common/init.sh
source ${ROOTDIR}/common/python.sh

PYTHON_RESTRICT="3"

get https://github.com/pygobject/pycairo/releases/download/v${PV}/${P}.tar.gz

cd "${P}"

pythonmesonsetup
archive
