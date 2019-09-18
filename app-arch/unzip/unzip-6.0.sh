#!/bin/sh
source "../../common/init.sh"

get https://downloads.sourceforge.net/infozip/unzip${PV//./}.tar.gz

cd "unzip${PV//./}"

make -f unix/Makefile generic
make prefix="${D}/pkg/main/${PKG}.core.${PVR}" MANDIR="${D}/pkg/main/${PKG}.doc.${PVR}/man" \
 -f unix/Makefile install

finalize
