#!/bin/sh
source "../../common/init.sh"

get http://mj.ucw.cz/download/linux/pci/${P}.tar.gz
acheck

cd "${P}"

importpkg zlib sys-fs/eudev

make PREFIX=/pkg/main/${PKG}.core.${PVRF} SHARED=yes ZLIB=yes OPT="-O2 ${CPPFLAGS}"
make install DESTDIR="${D}" PREFIX=/pkg/main/${PKG}.core.${PVRF} SHARED=yes ZLIB=yes

finalize
