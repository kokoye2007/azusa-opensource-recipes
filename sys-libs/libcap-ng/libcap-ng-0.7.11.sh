#!/bin/sh
source "../../common/init.sh"

get https://people.redhat.com/sgrubb/libcap-ng/${P}.tar.gz
acheck

importpkg libcrypt

cd "${T}"

if [ ! -d /usr/include ]; then
	ln -s /pkg/main/azusa.symlinks.core/full/include /usr/include
fi

doconf

make
make install DESTDIR="${D}"

finalize
