#!/bin/sh
source ../../common/init.sh
source ${ROOTDIR}/common/python.sh

get https://github.com/pygobject/pycairo/releases/download/v${PV}/${P}.tar.gz

cd "${P}"

pythonmesonsetup
archive
