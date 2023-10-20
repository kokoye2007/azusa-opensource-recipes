#!/bin/sh
source "../../common/init.sh"

# grab via git
fetchgit https://gitlab.freedesktop.org/glvnd/libglvnd.git "v${PV}"
acheck

importpkg x11

cd "${T}"

domeson -Dx11=enabled -Dglx=enabled

finalize
