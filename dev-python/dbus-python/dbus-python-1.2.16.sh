#!/bin/sh
source ../../common/init.sh
source "${ROOTDIR}"/common/python.sh

get https://dbus.freedesktop.org/releases/"${PN}"/"${P}".tar.gz
acheck

cd "${P}" || exit

pythonconfsetup
archive
