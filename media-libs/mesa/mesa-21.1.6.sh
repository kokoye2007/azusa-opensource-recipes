#!/bin/sh
source "../../common/init.sh"

get https://mesa.freedesktop.org/archive/${P}.tar.xz
acheck

GALLIUM_DRV="i915,nouveau,r600,radeonsi,svga,swrast,virgl"
DRI_DRIVERS="i965,nouveau"

cd "${T}"

importpkg zlib x11-libs/libxshmfence x11-libs/libXext x11-libs/libX11 x11-libs/libXxf86vm x11-libs/libXfixes x11-libs/libXdamage sys-libs/libunwind

meson --prefix="/pkg/main/${PKG}.core.${PVRF}" -Dbuildtype=release -Ddri-drivers=$DRI_DRIVERS -Dgallium-drivers=$GALLIUM_DRV -Dgallium-nine=false -Dglx=dri -Dosmesa=true -Dvalgrind=false "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
