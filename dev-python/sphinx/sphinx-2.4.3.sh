#!/bin/sh
source ../../common/init.sh
source ${ROOTDIR}/common/python.sh

PYTHON_RESTRICT="3"

MY_PN="Sphinx"
MY_P="${MY_PN}-${PV}"
get https://pypi.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz
acheck

cd "${MY_P}"

pythonsetup
archive
