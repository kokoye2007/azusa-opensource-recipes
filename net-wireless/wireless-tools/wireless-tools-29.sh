#!/bin/sh
source "../../common/init.sh"

get https://hewlettpackard.github.io/wireless-tools/wireless_tools.${PV}.tar.gz
acheck

cd */
patch -Np1 -i "$FILESDIR/wireless_tools-29-fix_iwlist_scanning-1.patch"

make
make install PREFIX="${D}/pkg/main/${PKG}.core.${PVR}"

finalize
