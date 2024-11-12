#!/bin/sh
source "../../common/init.sh"

get https://github.com/zeux/"${PN}"/releases/download/v"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

docmake

finalize
