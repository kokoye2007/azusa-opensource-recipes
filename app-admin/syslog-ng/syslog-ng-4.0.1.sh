#!/bin/sh
source "../../common/init.sh"

get https://github.com/balabit/syslog-ng/releases/download/${P}/${P}.tar.gz
acheck

cd "${T}"

importpkg json-c openssl dev-libs/hiredis

doconf --sysconfdir=/etc/syslog-ng --disable-java --disable-python

make
make install DESTDIR="${D}"

finalize
