#!/bin/sh
source "../../common/init.sh"

get https://dri.freedesktop.org/libdrm/${P}.tar.xz
acheck

cd "${T}"

importpkg app-arch/bzip2 sys-apps/util-linux dev-libs/libbsd

domeson -Dudev=true -Dcairo-tests=false -Damdgpu=true -Dexynos=true -Dfreedreno=true -Dintel=true -Dnouveau=true -Domap=true -Dradeon=true -Dtegra=true -Dvc4=true -Detnaviv=true -Dvmwgfx=true -Dlibkms=true -Dvalgrind=auto

finalize
