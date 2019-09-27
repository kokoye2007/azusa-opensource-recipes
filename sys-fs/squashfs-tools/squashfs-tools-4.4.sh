#!/bin/sh
source "../../common/init.sh"

get https://github.com/plougher/squashfs-tools/archive/${PV}.tar.gz

cd "${P}/squashfs-tools"

# make sure -lz works
export LDFLAGS="$(pkg-config zlib --libs-only-L)"

make
make install INSTALL_DIR="${D}/pkg/main/${PKG}.core.${PVR}/bin"

finalize
