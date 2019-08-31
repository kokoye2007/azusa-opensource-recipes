#!/bin/sh
source "../../common/init.sh"

get https://github.com/plougher/squashfs-tools/archive/${PV}.tar.gz

cd "${P}/squashfs-tools"

make
make install INSTALL_DIR="${D}/pkg/main/${PKG}.${PVR}/bin"

finalize
