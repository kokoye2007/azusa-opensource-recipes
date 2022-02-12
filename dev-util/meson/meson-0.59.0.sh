#!/bin/sh
source "../../common/init.sh"
source ${ROOTDIR}/common/python.sh

PYTHON_RESTRICT="3.10"

get https://github.com/mesonbuild/meson/releases/download/${PV}/${P}.tar.gz
acheck

cd "${P}"

pythonsetup
archive
