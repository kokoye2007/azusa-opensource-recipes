#!/bin/sh
source "../../common/init.sh"

get https://github.com/i-rinat/libvdpau-va-gl/archive/v"${PV}"/"${P}".tar.gz
acheck

cd "${T}" || exit

importpkg X

docmake

finalize
