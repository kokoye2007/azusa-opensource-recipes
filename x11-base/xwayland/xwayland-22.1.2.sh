#!/bin/sh
source "../../common/init.sh"

get https://www.x.org/archive/individual/xserver/"${P}".tar.xz
acheck

cd "${T}" || exit

domeson

finalize
