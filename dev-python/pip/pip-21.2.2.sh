#!/bin/sh
source ../../common/init.sh
source ${ROOTDIR}/common/python.sh

get https://github.com/pypa/${PN}/archive/${PV}.tar.gz

cd "${P}"

pythonsetup
archive
