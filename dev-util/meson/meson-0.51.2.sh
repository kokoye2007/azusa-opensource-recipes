#!/bin/sh
source "../../common/init.sh"
source ${ROOTDIR}/common/python.sh

PYTHON_RESTRICT="3.7"

get https://github.com/mesonbuild/meson/releases/download/${PV}/${P}.tar.gz

cd "${P}"

pythonsetup
archive
