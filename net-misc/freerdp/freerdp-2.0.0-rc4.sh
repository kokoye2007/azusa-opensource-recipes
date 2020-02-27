#!/bin/sh
source "../../common/init.sh"

get https://github.com/FreeRDP/FreeRDP/archive/${PV}.tar.gz
acheck

cd "FreeRDP-${PV}"
apatch "$FILESDIR/freerdp-2.0.0-rc4-fix-avcodec.patch"

cd "${T}"

CMAKE_ROOT="${CHPATH}/FreeRDP-${PV}" docmake -DWITH_LIBSYSTEMD=OFF -DCMAKE_C_FLAGS="-I/pkg/main/x11-base.xorg-proto.dev/include"

make
make install DESTDIR="${D}"

finalize
