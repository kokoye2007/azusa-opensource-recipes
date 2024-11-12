#!/bin/sh
source "../../common/init.sh"

get https://github.com/plougher/squashfs-tools/archive/"${PV}".tar.gz
acheck

cd "${P}/squashfs-tools" || exit

importpkg zlib

make
make install INSTALL_DIR="${D}/pkg/main/${PKG}.core.${PVRF}/bin"

# make sure we use the new mksquashfs binary
export PATH="${D}/pkg/main/${PKG}.core.${PVRF}/bin:$PATH"

finalize
