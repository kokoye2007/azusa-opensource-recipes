#!/bin/sh
source "../../common/init.sh"

get https://www.freedesktop.org/software/colord/releases/"${P}".tar.xz
acheck

importpkg media-libs/lcms

cd "${T}" || exit

domeson -Dsystemd=false -Ddaemon_user=colord

finalize
