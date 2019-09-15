#!/bin/sh
source "../../common/init.sh"

get https://mesa.freedesktop.org/archive/${P}.tar.xz

GALLIUM_DRV="i915,nouveau,r600,radeonsi,svga,swrast,virgl"
DRI_DRIVERS="i965,nouveau"

cd "${T}"

meson --prefix="/pkg/main/${PKG}.core.${PVR}" -Dbuildtype=release -Ddri-drivers=$DRI_DRIVERS -Dgallium-drivers=$GALLIUM_DRV -Dgallium-nine=false -Dglx=dri -Dosmesa=gallium -Dvalgrind=false "${CHPATH}/${P}"

ninja
DESTDIR="${D}" ninja install

finalize
