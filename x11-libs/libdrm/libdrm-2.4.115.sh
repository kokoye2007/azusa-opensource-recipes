#!/bin/sh
source "../../common/init.sh"

get https://dri.freedesktop.org/libdrm/${P}.tar.xz
acheck

cd "${T}"

importpkg app-arch/bzip2 sys-apps/util-linux dev-libs/libbsd

domeson -Dudev=true -Dcairo-tests=disabled -Damdgpu=enabled -Dexynos=enabled -Dfreedreno=enabled -Dintel=enabled -Dnouveau=enabled -Domap=enabled -Dradeon=enabled -Dtegra=enabled -Dvc4=enabled -Detnaviv=enabled -Dvmwgfx=enabled -Dvalgrind=auto

finalize
