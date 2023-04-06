#!/bin/sh
source "../../common/init.sh"

get https://github.com/FFmpeg/nv-codec-headers/releases/download/n${PV}/${P}.tar.gz
acheck

apatch "$FILESDIR/nv-codec-headers-11.1.5.2-cuda_lib_prefix.patch"

cd "${S}"

make PREFIX="/pkg/main/${PKG}.dev.${PVRF}" LIBDIR=
make DESTDIR="${D}" PREFIX="/pkg/main/${PKG}.dev.${PVRF}" LIBDIR= install

finalize
