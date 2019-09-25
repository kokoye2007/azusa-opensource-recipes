#!/bin/sh
source ../../common/init.sh
source ${ROOTDIR}/common/python.sh

get https://sourceforge.net/projects/scons/files/scons/${PV}/${P}.tar.gz

cd "${P}"

pythonsetup
archive
