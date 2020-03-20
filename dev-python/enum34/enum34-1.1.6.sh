#!/bin/sh
source ../../common/init.sh
source ${ROOTDIR}/common/python.sh

PYTHON_RESTRICT="2"

get https://pypi.org/packages/source/${PN:0:1}/${PN}/${P}.tar.gz
acheck

cd "${S}"

pythonsetup
archive
