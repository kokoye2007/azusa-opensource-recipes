#!/bin/sh
source "../../common/init.sh"

get https://www.mirrorservice.org/sites/lsof.itap.purdue.edu/pub/tools/unix/lsof/lsof_${PV}.tar.gz

cd "lsof_${PV}"

tar -xf lsof_${PV}_src.tar
cd lsof_${PV}_src

./Configure -n linux
make CFGL="-L./lib -ltirpc"

mkdir -p "${D}/pkg/main/${PKG}.core.${PVR}/bin" "${D}/pkg/main/${PKG}.doc.${PVR}/man/man8"

install -v -m0755 lsof "${D}/pkg/main/${PKG}.core.${PVR}/bin"
install -v lsof.8 "${D}/pkg/main/${PKG}.doc.${PVR}/man/man8"

finalize
