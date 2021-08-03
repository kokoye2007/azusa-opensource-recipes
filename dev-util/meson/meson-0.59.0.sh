#!/bin/sh
source "../../common/init.sh"
source ${ROOTDIR}/common/python.sh

PYTHON_RESTRICT="3.9"

get https://github.com/mesonbuild/meson/releases/download/${PV}/${P}.tar.gz
acheck

cd "${P}"

pythonsetup
archive
