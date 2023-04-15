#!/bin/sh
source "../../common/init.sh"

get https://people.redhat.com/sgrubb/libcap-ng/${P}.tar.gz
acheck

importpkg libcrypt sys-kernel/linux

cd "${T}"

doconf --with-capability_header=/pkg/main/azusa.symlinks.core/full/include/linux/capability.h

make
make install DESTDIR="${D}"

finalize
