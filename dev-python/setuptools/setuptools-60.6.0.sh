#!/bin/sh
source ../../common/init.sh
source ${ROOTDIR}/common/python.sh

PYTHON_RESTRICT="3"

get https://pypi.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz
acheck

cd "${P}"

pythonsetup
archive
