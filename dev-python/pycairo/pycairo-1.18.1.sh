#!/bin/sh
source ../../common/init.sh
source ${ROOTDIR}/common/python.sh

get https://github.com/pygobject/pycairo/releases/download/v1.18.1/${P}.tar.gz

cd "${P}"

pythonsetup
archive
