#!/bin/sh
source "../../common/init.sh"

get http://ftp.de.debian.org/debian/pool/main/liba/libaio/libaio_"${PV}".orig.tar.xz
acheck

cd "${P}" || exit

make prefix="/pkg/main/${PKG}.core.${PVRF}"
make install DESTDIR="${D}" prefix="/pkg/main/${PKG}.core.${PVRF}"

finalize
