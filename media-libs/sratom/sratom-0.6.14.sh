#!/bin/sh
source "../../common/init.sh"

get https://download.drobilla.net/"${P}".tar.xz
acheck

cd "${T}" || exit

domeson

finalize
