#!/bin/sh
source "../../common/init.sh"

get https://dri.freedesktop.org/libdrm/${P}.tar.bz2
acheck

cd "${T}"

importpkg app-arch/bzip2 sys-apps/util-linux dev-libs/libbsd

domeson -Dudev=false -Dcairo-tests=false -Damdgpu=true -Dexynos=false -Dfreedreno=false -Dintel=true -Dnouveau=true -Domap=false -Dradeon=true -Dtegra=false -Dvc4=false -Detnaviv=false -Dvmwgfx=false -Dlibkms=true -Dvalgrind=auto

finalize
