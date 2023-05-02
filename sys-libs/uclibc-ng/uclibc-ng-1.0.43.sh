#!/bin/sh
source "../../common/init.sh"

get https://downloads.uclibc-ng.org/releases/${PV}/uClibc-ng-${PV}.tar.xz
acheck

cd "${S}"

export PKG PVRF LIB_SUFFIX

cp -v "$FILESDIR/uclibc-1.0.43-${ARCH}" .config

make
make install DESTDIR="${D}"

mkdir -p "${D}/pkg/main/${PKG}.dev.${PVRF}"
skipsymlinks
finalize
