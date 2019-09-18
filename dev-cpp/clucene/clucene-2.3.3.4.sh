#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/clucene/clucene-core-${PV}.tar.gz

cd "clucene-core-${PV}"

patch -p1 <"$FILESDIR/clucene-2.3.3.4-contribs_lib-1.patch"

cd "${T}"

cmake "${CHPATH}/clucene-core-${PV}" -DCMAKE_INSTALL_PREFIX=/pkg/main/${PKG}.core.${PVR} -DBUILD_CONTRIBS_LIB=ON

make
make install DESTDIR="${D}"

finalize
