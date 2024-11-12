#!/bin/sh
source "../../common/init.sh"

MY_P="${P/-amber}"
MY_P="${MY_P/_/-}"
get https://archive.mesa3d.org/"${MY_P}".tar.xz
acheck

GALLIUM_DRV="i915,nouveau,r600,radeonsi,svga,swrast,virgl"
DRI_DRIVERS="i965,nouveau"

importpkg dev-libs/wayland x11-libs/libxcb

cd "${T}" || exit

importpkg zlib x11-libs/libxshmfence x11-libs/libXext x11-libs/libX11 x11-libs/libXxf86vm x11-libs/libXfixes x11-libs/libXdamage sys-libs/libunwind

domeson -Ddri-drivers=$DRI_DRIVERS -Dgallium-drivers=$GALLIUM_DRV -Dgallium-nine=false -Dglx=dri -Dosmesa=true -Dvalgrind=false

finalize
