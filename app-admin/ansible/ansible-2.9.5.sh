#!/bin/sh
source "../../common/init.sh"
inherit python

PYTHON_RESTRICT="3.8"

get https://releases.ansible.com/"${PN}"/"${P}".tar.gz
acheck

cd "${S}" || exit

pythonsetup

finalize
