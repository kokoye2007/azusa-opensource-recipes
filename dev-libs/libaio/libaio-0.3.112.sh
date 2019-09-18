#!/bin/sh
source "../../common/init.sh"

get http://ftp.de.debian.org/debian/pool/main/liba/libaio/libaio_${PV}.orig.tar.xz

cd "${P}"

make prefix="/pkg/main/${PKG}.core.${PVR}"
make install DESTDIR="${D}" prefix="/pkg/main/${PKG}.core.${PVR}"

finalize
