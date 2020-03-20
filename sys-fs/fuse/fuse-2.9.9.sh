#!/bin/sh
source "../../common/init.sh"

get https://github.com/libfuse/libfuse/releases/download/${P}/${P}.tar.gz
acheck

cd "${S}"

# disable examples
echo -n >example/meson.build

cd "${T}"

doconf --disable-example --disable-static INIT_D_PATH=/etc/init.d MOUNT_FUSE_PATH="/pkg/main/${PKG}.core.${PVR}/sbin"

make
make install DESTDIR="${D}"

finalize
