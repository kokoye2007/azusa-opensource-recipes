#!/bin/sh
source "../../common/init.sh"
source ${ROOTDIR}/common/python.sh

get https://files.pythonhosted.org/packages/a5/1f/c7c5450c60a90ce058b47ecf60bb5be2bfe46f952ed1d3b95d1d677588be/Cython-${PV}.tar.gz
#get https://pypi.org/packages/source/${PN:0:1}/${PN}/${P}.zip
acheck

cd "Cython-${PV}"

pythonsetup
archive
