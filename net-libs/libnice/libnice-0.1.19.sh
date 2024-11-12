#!/bin/sh
source "../../common/init.sh"

get https://nice.freedesktop.org/releases/"${P}".tar.gz
acheck

cd "${T}" || exit

domeson

finalize
