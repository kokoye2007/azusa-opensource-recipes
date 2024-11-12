#!/bin/sh
source "../../common/init.sh"

get https://gstreamer.freedesktop.org/src/"${PN}"/"${P}".tar.xz
acheck

cd "${T}" || exit

domeson

finalize
