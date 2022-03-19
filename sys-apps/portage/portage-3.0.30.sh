#!/bin/sh
source "../../common/init.sh"
source ${ROOTDIR}/common/python.sh

PYTHON_RESTRICT="$PYTHON_LATEST"

get https://gitweb.gentoo.org/proj/portage.git/snapshot/${P}.tar.bz2
acheck

cd "${P}"

pythonsetup
archive
