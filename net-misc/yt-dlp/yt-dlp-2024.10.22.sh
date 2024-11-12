#!/bin/sh
source "../../common/init.sh"
source "${ROOTDIR}"/common/python.sh

PYTHON_RESTRICT="$PYTHON_LATEST"

get https://github.com/yt-dlp/yt-dlp/releases/download/"${PV}"/"${PN}".tar.gz "${P}".tar.gz
acheck

cd "${S}" || exit

pythonsetup

finalize
