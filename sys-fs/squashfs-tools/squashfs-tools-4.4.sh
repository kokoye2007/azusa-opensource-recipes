#!/bin/sh
source "../../common/init.sh"

get https://github.com/plougher/squashfs-tools/archive/${PV}.tar.gz
acheck

cd "${P}/squashfs-tools"

importpkg zlib

make
make install INSTALL_DIR="${D}/pkg/main/${PKG}.core.${PVR}/bin"

finalize
