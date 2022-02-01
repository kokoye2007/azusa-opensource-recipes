#!/bin/sh
source ../../common/init.sh
source ${ROOTDIR}/common/python.sh

PYTHON_RESTRICT="3"

get https://github.com/pypa/${PN}/archive/${PV}.tar.gz
acheck

cd "${P}"

pythonsetup
archive
