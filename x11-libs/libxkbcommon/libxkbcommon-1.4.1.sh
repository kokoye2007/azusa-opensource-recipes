#!/bin/sh
source "../../common/init.sh"

get https://xkbcommon.org/download/"${P}".tar.xz
acheck

cd "${T}" || exit

domeson

finalize
