#!/bin/sh
source "../../common/init.sh"
source ${ROOTDIR}/common/python.sh

get https://home.apache.org/~arfrever/distfiles/${P}.tar.xz

cd "${P}"

pythonsetup
archive
